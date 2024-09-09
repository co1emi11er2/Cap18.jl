using Cap18
h1 = Header1()
write(h1)

h2 = Header2()
write(h2)

pc = ProblemCard(
       problem_num_5="1",
       unit_system_1='E',
       description_65="problem description"
       )
write(pc)

tb1 = Table1(
       srs_option=true,
       keep_env_from_prev_prob=false,
       keep_table2_from_prev_prob=false,
       keep_table3_from_prev_prob=false,
       keep_table4_from_prev_prob=false,
       card_inputs=15,
       clear_envelopes_before_lane_loading=false,
       print_option=0,
       skew=0)
write(tb1)

tb2 = Table2(
num_increments_slab=80,
increment_length=0.5,
num_total_increments_moving=20,
mov_start_sta=2,
mov_end_sta=58,
num_btwn_increments_moving=1,
analysis_option=3,
dl_factor=1.25,
overlay_factor=1.50,
ll_factor=1.75,
max_lanes_loaded=3,
mult_presence_factor=[1.2, 1.0, 0.85, 0.65, 0.65],
)
write(tb2)

tb3 = Table3(
num_lanes=3,
num_stringers=5,
num_supports=3,
num_moment_points=11,
num_shear_points=3,
sta_lane_left=[2, 26, 54],
sta_lane_right=[26, 54, 78],
sta_stringers=[6, 23, 40, 57, 74],
sta_supports=[10, 40, 70],
sta_moment_points=[6, 10, 19, 23, 33, 40, 47, 57, 60, 65, 70],
sta_shear_points=[8, 12, 38],
)
write(tb3)


data = StiffnessLoadData[
    StiffnessLoadData("(CAP EI & DL)", 2, 78, 0, 4.6e6, 0.0, -0.792, 0.0, 0.0), 
    StiffnessLoadData("(DL Span1, Bm1)", 6, 6, 0, 0.0, 0.0, -92.19, -9.92, 0.0), 
    StiffnessLoadData("(DL Span1, Bm2)", 23, 23, 0, 0.0, 0.0, -92.19, -9.92, 0.0), 
    StiffnessLoadData("(DL Span1, Bm3)", 40, 40, 0, 0.0, 0.0, -92.19, -9.92, 0.0), 
    StiffnessLoadData("(DL Span1, Bm4)", 57, 57, 0, 0.0, 0.0, -92.19, -9.92, 0.0), 
    StiffnessLoadData("(DL Span1, Bm5)", 74, 74, 0, 0.0, 0.0, -92.19, -9.92, 0.0), 
    StiffnessLoadData("(DL Span5, Bm1)", 6, 6, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(DL Span5, Bm2)", 20, 20, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(DL Span5, Bm3)", 33, 33, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(DL Span5, Bm4)", 47, 47, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(DL Span5, Bm5)", 60, 60, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(DL Span5, Bm6)", 74, 74, 0, 0.0, 0.0, -98.62, -9.52, 0.0), 
    StiffnessLoadData("(Dist. Lane Ld)", 0, 20, 0, 0.0, 0.0, 0.0, 0.0, -5.86), 
    StiffnessLoadData("(Conc. Lane Ld)", 4, 4, 0, 0.0, 0.0, 0.0, 0.0, -21.3), 
    StiffnessLoadData("(Conc. Lane Ld)", 16, 16, 0, 0.0, 0.0, 0.0, 0.0, -21.3)]
tb4 = Table4(data)
write(tb4)