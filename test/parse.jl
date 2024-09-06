import Cap18: parse_cap18, Table1, Table2, Table3

dir = @__DIR__
path = dir * "/../test/t.lis"
p = parse_cap18(path)

# Check Problem 1, Table 1
expected_table1 = Table1(
    srs_option=false,
    keep_env_from_prev_prob=false,
    keep_table2_from_prev_prob=false,
    keep_table3_from_prev_prob=false,
    keep_table4_from_prev_prob=false,
    card_inputs=21,
    clear_envelopes_before_lane_loading=false,
    print_option=0,
    skew=0.0
)
calc_table1 = p[1].tb1
@test calc_table1 == expected_table1

# Check Problem 1, Table 2
expected_table2 = Table2(
    num_increments_slab=61,
    increment_length=0.5,
    num_total_increments_moving=20,
    mov_start_sta=2,
    mov_end_sta=39,
    num_btwn_increments_moving=1,
    analysis_option=3,
    dl_factor=1.25,
    overlay_factor=1.5,
    ll_factor=1.75,
    max_lanes_loaded=2,
    mult_presence_factor=[1.2, 1.0],
    )
calc_table2 = p[1].tb2
for field in fieldnames(typeof(calc_table2))
    @test getfield(calc_table2, field) == getfield(expected_table2, field)
end

# Check Problem 1, Table 3
expected_table3 = Table3(
    num_lanes=2, 
    num_stringers=4, 
    num_supports=3, 
    num_moment_points=7, 
    num_shear_points=6, 
    sta_lane_left=[2, 30], 
    sta_lane_right=[30, 59], 
    sta_stringers=[6.0, 22.0, 39.0, 55.0], 
    sta_supports=[8.0, 30.0, 52.0], 
    sta_moment_points=[6.0, 8.0, 22.0, 30.0, 39.0, 52.0, 55.0], 
    sta_shear_points=[4.0, 10.0, 28.0, 32.0, 50.0, 57.0]
    )
calc_table3 = p[1].tb3
for field in fieldnames(typeof(calc_table3))
    @test getfield(calc_table3, field) == getfield(expected_table3, field)
end