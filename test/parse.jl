import Cap18: parse_cap18, Table1

p = parse_cap18()

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

@test p[1].tb1 == expected_table1