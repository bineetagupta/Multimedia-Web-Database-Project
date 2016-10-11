#include<iostream>
#include<cstdlib>
#include<string>
#include<map>
#include<vector>
#include<sstream>
#include<memory>// Remember to include the -std=c++0x flag in g++ for compilation
#include "parser.h"
using namespace std;

parser::parser(int res)
{
    //ctor
    r=res;
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
			b_same_video=(vid_no==last_vid_no)?true:false;
			last_vid_no=vid_no;
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
	catch(exception e)
	{
		exit(1);
	}
}

void parser::reset_curr_frame()
{
	curr_frame=t_ptr_frame(new t_frame(f_no,r));
}

void parser::add_old_frame_to_video()
{
    curr_video_frames.push_back(curr_frame);
}

void parser::reset_curr_video()
{
    videos.insert(make_pair(vid_no,curr_video_frames));
    curr_video_frames=t_frames();
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

        for( ;fit!=vid_frames.end();fit++)
        {
            for(int j=0;j<n_cells;j++)
            {
                cout<<i<<","<<(*fit)->f_no<<","<<(*fit)->cells[j].cell_no<<",";//j should be equal to c-1, but this is what we're checking
                histogram h=(*fit)->cells[j].hist;
                t_hist_it hit=h.begin();
                for( ;hit!=h.end();hit++)
                {
                    cout<<*hit<<"#";
                }
                cout<<endl;
            }
        }

    }
}

int main()
{
	int r;
	//if(argc>=1)
	{
	    cin >>r;
	    parser p=parser(r);
        p.read_and_store_records();
        p.print();
	}
	//else
		//cout<< "\nMissing parameter value.\nUsage: ./task1a.exe <r>";
	return 0;
}

