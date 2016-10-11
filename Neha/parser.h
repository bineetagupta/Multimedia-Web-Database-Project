#ifndef PARSER_H
#define PARSER_H

#include<iostream>
#include<cstdlib>
#include<string>
#include<map>
#include<vector>
#include<sstream>
#include<memory>// Remember to include the -std=c++0x flag in g++ for compilation
using namespace std;


class parser
{
    public:
        /** Default constructor */
        parser(int r);
        /** Default destructor */
        virtual ~parser();
        void read_and_store_records();
        void tokenize_record_and_store_in_map(const string & record);
        void tokenize_record(const string & record);
        void reset_curr_frame();
        void add_old_frame_to_video();
        void reset_curr_video();
        void print();
    protected:
        typedef int t_video_num;
        typedef vector<int> histogram;
        typedef histogram::iterator t_hist_it;
        class t_cell
        {
            public:
            int cell_no;
            histogram hist;
        };

        class t_frame
        {
            public:
            int f_no;
            t_cell* cells;
            t_frame(int f, int r)
            {
                //frame number
                f_no=f;
                //allocate cells by size
                cells=new t_cell[r*r];
            }
            ~t_frame()
            {
                //deallocate cells
                delete[] cells;
            }
        };
        typedef shared_ptr<t_frame> t_ptr_frame;
        typedef vector<t_ptr_frame> t_frames;
        typedef map<t_video_num, t_frames> t_videos_map;
        typedef t_videos_map::iterator t_video_iterator;
        typedef t_frames::iterator t_frames_iterator;

        t_videos_map videos;
        t_video_iterator vid_iterator;
        t_frames curr_video_frames;
        t_frames_iterator f_iterator;
        t_ptr_frame curr_frame;
        int r,n;
        int vid_no,f_no,c;
        int last_vid_no=-1;
        bool b_same_video=false;
        int last_frame_no=-1;
        bool b_same_frame=false;

    private:
};

#endif // PARSER_H
