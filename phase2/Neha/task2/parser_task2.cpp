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
#include "parser_task2.h"
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
	add_old_frame_to_video();
	reset_curr_video();//store the last video after the last record is read
	
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
			b_same_video=(vid_no==last_vid_no || last_vid_no==-1)?true:false;
			if(last_vid_no==-1)
				last_vid_no=vid_no;
		}
		//get the frame number
		if(std::getline(ss, token, ','))
		{
			f_no=atoi(token.c_str());
			b_same_frame=(b_same_video && f_no==last_frame_no)?true:false;
			//last_frame_no=f_no;
		}
		//if this is a new frame, push the old one into the videos vector and update the current frame
		if(!b_same_frame)//
        {
			if(last_frame_no!=-1)
				add_old_frame_to_video();
            reset_curr_frame();
			
        }
		last_frame_no=f_no;

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
    for(int i=1;i<=10;i++)
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

double parser::cell_dist_manhattan(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2)
{
	histogram h1=c1.hist;
	histogram h2=c2.hist;
	double dist=0;
	for(int i=0;i<n;i++)
	{
		dist+=fabs(double(h1[i])/pix_cnt1 - double(h2[i])/pix_cnt2);
	}
}

double parser::cell_dist_intersect(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2)
{
	histogram h1=c1.hist;
	histogram h2=c2.hist;
	double dist=0,max=0,min=0;
	for(int i=0;i<n;i++)
	{
		max+=(double(h1[i])/pix_cnt1) > (double(h2[i])/pix_cnt2)?(double(h1[i])/pix_cnt1):(double(h2[i])/pix_cnt2);
		min+=(double(h1[i])/pix_cnt1) > (double(h2[i])/pix_cnt2)?(double(h2[i])/pix_cnt2):(double(h1[i])/pix_cnt1);
	}
	dist=min/max;
}


double parser::cell_dist_chi_sq(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2)
{
	histogram h1=c1.hist;
	histogram h2=c2.hist;
	double dist=0,x1=0,x2=0;
	for(int i=0;i<n;i++)
	{
		x1=(double(h1[i])/pix_cnt1);
		x2=(double(h2[i])/pix_cnt2);
		if(x1!=0 || x2!=0)
			dist+=(fabs(x1-x2)/(x1+x2));
		//if(x1!=0)
			//dist+=(pow(x1-x2,2)/(x1));
	}
	return dist;//no normalization here, normalise at the frame level
}


double parser::frame_dist_manhattan(t_frame& f1, t_frame& f2)
{
	int total_cells=r*r;
	double dist=0,cell_dist,max_dist=0;
	int f1_pix_cnt=f1.get_pixel_per_cell();
	int f2_pix_cnt=f2.get_pixel_per_cell();
	for(int i=0;i<total_cells;i++)
	{
		cell_dist=cell_dist_manhattan(f1.cells[i], f2.cells[i],f1_pix_cnt,f2_pix_cnt);
		if(cell_dist>max_dist)
			max_dist=cell_dist;
		dist+=cell_dist;
	}
	return (dist/(max_dist*total_cells));
}

double parser::frame_dist_intersect(t_frame& f1, t_frame& f2)
{
	int total_cells=r*r;
	double dist=0;
	int f1_pix_cnt=f1.get_pixel_per_cell();
	int f2_pix_cnt=f2.get_pixel_per_cell();
	for(int i=0;i<total_cells;i++)
		dist+=cell_dist_intersect(f1.cells[i], f2.cells[i],f1_pix_cnt,f2_pix_cnt);
	return (dist/total_cells);
}

double parser::frame_dist_ch_sq(t_frame& f1, t_frame& f2)
{
	int total_cells=r*r;
	double dist=0,cell_dist,max_dist=0;
	int f1_pix_cnt=f1.get_pixel_per_cell();
	int f2_pix_cnt=f2.get_pixel_per_cell();
	for(int i=0;i<total_cells;i++)
	{
		cell_dist=cell_dist_chi_sq(f1.cells[i], f2.cells[i],f1_pix_cnt,f2_pix_cnt);
		if(cell_dist>max_dist)
			max_dist=cell_dist;
		dist+=cell_dist;
	}
	//return (dist/(max_dist*total_cells));
	return (dist/(total_cells));
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

double parser::get_score_for_subseq(t_frames vid1, t_frames vid2)
{
	int m=vid1.size();
	int n=vid2.size();
	double** dist_matrix=new double*[m];
	
	for(int i=0;i<m;i++)
		dist_matrix[i]=new double[n];
	//initialise all distance matrix values to infinity
	for(int i=0;i<m;i++)
		for(int j=0;j<n;j++)
			dist_matrix[i][j]=DBL_MAX;
	//initialise the distance measure for the first frame pair
	t_frames_iterator f1=vid1.begin();
	t_frames_iterator f2=vid2.begin();
	//dist_matrix[0][0]=frame_dist_ch_sq(**f1,**f2)*2.0/(m+n);
	dist_matrix[0][0]=frame_dist_intersect(**f1,**f2)*2.0/(m+n);
	
	//start the DP to calculate minimum sum aligned sequence of frames
	double d,d1,d2,d3;
	t_frames_iterator fit1=vid1.begin();
	if(fit1==vid1.end())
	{
		cout<<"\n first video is in the map but has no frames!!";
		exit(1);
	}
	fit1++;
	
	for(int i=1; fit1 != vid1.end() && i<m; ++fit1,++i)
	{
		t_frames_iterator fit2=vid2.begin();
		if(fit2==vid2.end())
		{
			cout<<"\n second video is in the map but has no frames!!";
			exit(1);
		}
		fit2++;
		for(int j=1; fit2 != vid2.end() && j<n; ++fit2,++j)
		{
			double min=0;
			//d=frame_dist(**fit1,**fit2)/(m+n);
			//d=frame_dist_ch_sq(**fit1,**fit2)/(m+n);
			d=frame_dist_intersect(**fit1,**fit2)/(m+n);
			d1=dist_matrix[i-1][j-1]+2*d;
			d2=dist_matrix[i][j-1]+d;
			d3=dist_matrix[i-1][j]+d;
			min=d1<d2?d1:d2;
			dist_matrix[i][j]=d3<min?d3:min;
		}	
	}
	double score=dist_matrix[m-1][n-1];
	
	for(int i=0;i<m;i++)
		delete dist_matrix[i];
	
	delete[] dist_matrix;
	
	return score;
	//print out the value of the min dist path which is: dist_matrix[m-1][n-1]
	//cout<<"\nScore for video "<<v1<<" and video "<<v2<<" : "<<setprecision(8)<<dist_matrix[m-1][n-1]<<endl;
}
void parser::cal_subseq(int v1, int v2, int a, int b, t_top_k_map & store_dist)// make all parameters const references
{
	t_video_iterator vit1=videos.find(v1);
	t_video_iterator vit2=videos.find(v2);
	//int n = vit1->second.size();
	if(vit1!=videos.end() && vit2!=videos.end())
	{
		t_frames vid1_whole=vit1->second;
		t_frames::const_iterator first = vid1_whole.begin() + a;
		t_frames::const_iterator last = vid1_whole.begin() + b;
		t_frames vid1(first, last);
		
		t_frames vid2_whole=vit2->second;
		int n=vid2_whole.size();
		
		int qsz=vid1.size();
		int alpha = qsz*0.8;
		int beta = qsz*1.2;
		int step= (qsz/2);
		
		for(int k=alpha; k<=beta; k++)
		{
			for(int j=0; j+k-1<n; j+=step)
			{
				// cal similarity b/w input query video and k-sized window in vid2_whole starting at j and ending at j+k-1
				t_frames::const_iterator first = vid2_whole.begin() + j;
				t_frames::const_iterator last = vid2_whole.begin() + j+k-1;
				t_frames vid2(first, last);
				double score=get_score_for_subseq(vid1, vid2);
				pair<int, int> frame_range=make_pair(j,j+k-1);
				pair<int, pair<int,int>> vid_frm_range=make_pair(v2, frame_range);
				store_dist.insert(make_pair(score, vid_frm_range));
				cout<<"\nScore for similraity between query and video "<<v2<<" frame range ["<<j << ","<< j+k-1 <<"] : "<<setprecision(8)<<score<<endl;
			}
		}
	}
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
		//dist_matrix[0][0]=frame_dist_ch_sq(**f1,**f2)*2.0/(m+n);
		dist_matrix[0][0]=frame_dist_intersect(**f1,**f2)*2.0/(m+n);
		
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
				//d=frame_dist(**fit1,**fit2)/(m+n);
				//d=frame_dist_ch_sq(**fit1,**fit2)/(m+n);
				d=frame_dist_intersect(**fit1,**fit2)/(m+n);
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
        //p.print();
	
	//else
		//cout<< "\nMissing parameter value.\nUsage: ./task1a.exe <r>";
	
	int vi=10;
	int a=30;
	int b=40;
	int k=5;
	t_top_k_map top_k_map; 
	for(int i=1;i<=p.number_of_vid();i++)
	{
		double score = p.cal_subseq(vi, i, a, b, top_k_map);
	}
	p.get_
	return 0;
}

