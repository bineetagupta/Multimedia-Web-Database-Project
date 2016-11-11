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

typedef map<double, pair<int, pair<int,int>>> t_top_k_map;// assumption ignoring repeated same score
typedef map<double, pair<int, pair<int,int>>>::iterator t_top_k_map_iterator;

class parser
{
    public:
	
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
			int n_bin;
			int pixel_per_cell;
			bool is_pixel_count_calculated;
			
            t_frame(int f, int r, int n)
            {
                //frame number
                f_no=f;
				n_bin=n;
                cells=new t_cell[r*r];
				pixel_per_cell=0;
				is_pixel_count_calculated=false;
            }
            ~t_frame()
            {
                //deallocate cells
                delete[] cells;
            }
	
			int get_pixel_per_cell();
        };
		typedef shared_ptr<t_frame> t_ptr_frame;
        typedef vector<t_ptr_frame> t_frames;
        typedef map<t_video_num, t_frames> t_videos_map;
        typedef t_videos_map::iterator t_video_iterator;
        typedef t_frames::iterator t_frames_iterator;

        
        /** Default constructor */
        parser(int r,int n);
        /** Default destructor */
        virtual ~parser();
        void read_and_store_records();
        void tokenize_record_and_store_in_map(const string & record);
        void tokenize_record(const string & record);
        void reset_curr_frame();
        void add_old_frame_to_video();
        void reset_curr_video();
		double get_score(int v1, int v2);
		void cal_subseq(int v1, int v2, int a, int b, t_top_k_map & store_dist);// make all parameters const references
		double get_score_for_subseq(t_frames vid1, t_frames vid2);
		double frame_dist_manhattan(t_frame& f1, t_frame& f2);
		double frame_dist_intersect(t_frame& f1, t_frame& f2);
		double frame_dist_ch_sq(t_frame& f1, t_frame& f2);
		double cell_dist_manhattan(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2);
		double cell_dist_intersect(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2);
		double cell_dist_chi_sq(t_cell c1, t_cell c2, int pix_cnt1, int pix_cnt2);
        void print();
		int number_of_vid()
		{
			return videos.size();
		}
    protected:
        
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
