#include<iostream>
#include<cstdlib>
#include<cmath>
#include<iomanip>
#include<cfloat>
#include<string>
#include<map>
#include<vector>
#include<sstream>
#include<memory>// Remember to include the -std=c++0x flag in g++ for compilation
#include "parser.h"
using namespace std;

parser::parser(int res,int bin_size)
{
    //ctor
    r=res;
	n=bin_size;
}

parser::~parser()
{
    //dtor
}

void parser::read_and_store_records()
{
	string record;
	cin >> record;//discard the first header line
	while(cin>>record)
	{
		tokenize_record_and_store_in_map(record);
	}
}


void parser::tokenize_record_and_store_in_map(const string & record)
{
	tokenize_record(record);

	if(!b_same_video)
	{
		//lookup in map if the video is there
		vid_iterator = videos.find(vid_no);
        //if video is in the map
		if(vid_iterator!=videos.end())//- it should not be tru, since the records for one video are together
			curr_video_frames=vid_iterator->second;
		else
            reset_curr_video();
	}
}


void parser::tokenize_record(const string & record)
{
	try
	{
		istringstream ss(record);
		b_same_frame=false;
		string token;

		//get the video number/name
		if(std::getline(ss, token, ','))
		{
			vid_no=atoi(token.c_str()); //Add assumption in report: each video file name starts with a unique numerical string; alternatively you can change the code to map each video name to a number and output the mapping somewhere.
			if(last_vid_no==-1)
				last_vid_no=vid_no;
			b_same_video=(vid_no==last_vid_no)?true:false;
		}
		//get the frame number
		if(std::getline(ss, token, ','))
		{
			f_no=atoi(token.c_str());
			b_same_frame=(b_same_video && f_no==last_frame_no)?true:false;
			last_frame_no=f_no;
		}
		//if this is a new frame, push the old one into the videos vector and update the current frame
		if(!b_same_frame)
        {
            add_old_frame_to_video();
            reset_curr_frame();
        }

		// get the cell number and corresponding histogram

		if(std::getline(ss, token, ','))
        {
            c=atoi(token.c_str());
            curr_frame->cells[c-1].cell_no=c;
        }

		if(std::getline(ss, token, ','))
		{
			istringstream sshist(token);
			string tok;
			for(int j=0;j<10;j++)
			{
				std::getline(sshist, tok, '#');
				curr_frame->cells[c-1].hist.push_back(atoi(tok.c_str()));
			}
		}
	}
	catch(...)
	{
		cout<<"\nException!!";
		exit(1);
	}
}

void parser::reset_curr_frame()
{
	curr_frame=t_ptr_frame(new t_frame(f_no,r,n));
}

void parser::add_old_frame_to_video()
{
    curr_video_frames.push_back(curr_frame);
}

void parser::reset_curr_video()
{
    videos.insert(make_pair(last_vid_no,curr_video_frames));
    curr_video_frames=t_frames();
	last_vid_no=vid_no;
}

void parser::print()
{
    int n_cells=r*r;
    for(int i=1;i<=vid_no;i++)
    {
        //find the ith video
        t_video_iterator vit=videos.find(i);
        t_frames vid_frames;
        if(vit!=videos.end())
            vid_frames=vit->second;
        t_frames_iterator fit=vid_frames.begin();

        for( ;fit!=vid_frames.end();++fit)
        {
            for(int j=0;j<n_cells;j++)
            {
                cout<<i<<","<<(*fit)->f_no<<","<<(*fit)->cells[j].cell_no<<",";//j should be equal to c-1, but this is what we're checking
                histogram h=(*fit)->cells[j].hist;
                t_hist_it hit=h.begin();
                for( ;hit!=h.end();++hit)
                {
                    cout<<*hit<<"#";
                }
                cout<<endl;
            }
        }

    }
}

double parser::cell_dist(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2)
{
	histogram h1=c1.hist;
	histogram h2=c2.hist;
	double dist=0;
	for(int i=0;i<n;i++)
	{
		dist+=fabs(double(h1[i])/pix_cnt1 - double(h2[i])/pix_cnt2);
	}
}

double parser::frame_dist(t_frame& f1, t_frame& f2)
{
	int total_cells=r*r;
	double dist=0;
	int f1_pix_cnt=f1.get_pixel_per_cell();
	int f2_pix_cnt=f2.get_pixel_per_cell();
	for(int i=0;i<total_cells;i++)
		dist+=cell_dist(f1.cells[i], f2.cells[i],f1_pix_cnt,f2_pix_cnt);
	return dist;
}

int parser::t_frame::get_pixel_per_cell()
{
	if(is_pixel_count_calculated)
		return pixel_per_cell;
	
	pixel_per_cell=0;
	for(int i=0;i<n_bin;i++)
	{
		pixel_per_cell+=cells[0].hist[i];
	}
	is_pixel_count_calculated=true;
	return pixel_per_cell;
}

double parser::get_score(int v1, int v2)
{
	t_video_iterator vit1=videos.find(v1);
	t_video_iterator vit2=videos.find(v2);
	if(vit1!=videos.end() && vit2!=videos.end())
	{
		t_frames vid1=vit1->second;
		t_frames vid2=vit2->second;
		int m=vid1.size();
		int n=vid2.size();
		double** dist_matrix=new double*[m];
		
		for(int i=0;i<n;i++)
			dist_matrix[i]=new double[n];
		//initialise all distance matrix values to infinity
		for(int i=0;i<m;i++)
			for(int j=0;j<n;j++)
				dist_matrix[i][j]=DBL_MAX;
		//initialise the distance measure for the first frame pair
		t_frames_iterator f1=vit1->second.begin();
		t_frames_iterator f2=vit2->second.begin();
		dist_matrix[0][0]=frame_dist(**f1,**f2)*2.0/(m+n);
		
		//start the DP to calculate minimum sum aligned sequence of frames
		double d,d1,d2,d3;
		t_frames_iterator fit1=vid1.begin();
		if(fit1==vid1.end())
		{
			cout<<"\n video "<< v1 <<" is in the map but has no frames!!";
			exit(1);
		}
		fit1++;
		
		for(int i=1; fit1 != vid1.end() && i<m; ++fit1,++i)
		{
			t_frames_iterator fit2=vid2.begin();
			if(fit2==vid2.end())
			{
				cout<<"\n video "<< v2 <<" is in the map but has no frames!!";
				exit(1);
			}
			fit2++;
			for(int j=1; fit2 != vid2.end() && j<n; ++fit2,++j)
			{
				double min=0;
				d=frame_dist(**fit1,**fit2)/(m+n);
				d1=dist_matrix[i-1][j-1]+2*d;
				d2=dist_matrix[i][j-1]+d;
				d3=dist_matrix[i-1][j]+d;
				min=d1<d2?d1:d2;
				dist_matrix[i][j]=d3<min?d3:min;
			}	
		}
		//print out the value of the min dist path which is: dist_matrix[m-1][n-1]
		cout<<"\nScore for video "<<v1<<" and video "<<v2<<" : "<<setprecision(8)<<dist_matrix[m-1][n-1]<<endl;
	}
}

int main()
{
	int r,n;
	//if(argc>=1)
	
	    cin >>r>>n;// see if this would work
	    parser p=parser(r,n);
        p.read_and_store_records();
        p.print();
	
	//else
		//cout<< "\nMissing parameter value.\nUsage: ./task1a.exe <r>";
	p.get_score(1,6);
	p.get_score(5,6);
	p.get_score(1,5);
	p.get_score(2,3);
	p.get_score(2,4);
	p.get_score(3,4);
	p.get_score(2,5);
	p.get_score(2,6);
	//p.get_score(1,3);
	/*while(true)
	{
		cout<<"Enter videos to compare(0 to exit):";
		cin>> v1>> v2;
		if(v1!=0 && v2!=0)
			double s=p.get_score(v1,v2);
		else
			break;
	}
	*/
	
	return 0;
}

