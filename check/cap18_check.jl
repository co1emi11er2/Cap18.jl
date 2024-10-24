### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 19350050-6259-11ef-08a2-45f6e65cb86d
begin
    import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
    Pkg.instantiate()
	using Revise
    using Plots, PlutoUI, DataFrames, CSV, Tidier
	using Cap18, PlutoLinks
	import StatsPlots as stats
	using BentTool, StructuralUnits
end

# ╔═╡ 649dac4c-c164-48f5-9fb9-ca12050f15c3
html"""<style>
main {
    max-width: 900px;
    align-self: flex-start;
    margin-left: 50px;
}
"""

# ╔═╡ 4a04e883-3b3a-45ee-9cc2-14dbf982ea80
PlutoUI.TableOfContents()

# ╔═╡ 24457ac2-d608-440b-9c48-6510717b6fb7
dir = pwd()

# ╔═╡ c7bb8e6e-64fd-4cd6-b4ea-15883b9ce5ce
plotlyjs()

# ╔═╡ a3fc2e85-ef06-4a1b-b3ba-06c8b1ac82d1
begin
	legend_pos = :outertopright
	x_size = 721
	y_size = 600
end;

# ╔═╡ 8d1bdea9-9449-4b02-9476-a56da73cdbc4
md"# Example 2 - Six Column Bent (Back Span)"

# ╔═╡ 5e45710b-70ec-4753-accb-f5c34488da5e
md"""
Example 2 was run for both Larsa and Cap18. Example 2 needed two separate runs to effectively analyze for the backspan and the forward span. This is the analysis of the back span part of the example. Below is a short summary of the bent details.

Bent Details:
- 9 Tx54 backspan girders
- 10 Tx54 forwardspan girders
- 78' wide bent
- 6 columns spaced at 14'
"""

# ╔═╡ bc70b875-ad7a-4db9-b0cc-c3c05f6f7be1
begin
r = RectangularColumn(42, 42, 20);
col_info = ColumnInfo(r, 6, [4ft, 14ft, 14ft, 14ft, 14ft, 14ft]);
bar_a = BarAInfo(Bar("#11"), 4, 12);
bar_b = BarBInfo(Bar("#11"), 4, 10);
bar_s = BarSInfo(Bar("#6"));
bar_t = BarTInfo(Bar("#6"), 6);
cap = RectangularBentCap(
	length= 78ft,
	width= 4ft,
	depth= 4ft,
	bar_a_info= bar_a,
	bar_b_info= bar_b,
	bar_s_info= bar_s,
	bar_t_info= bar_t,
	column_info= col_info,
	offset= 0ft,
);
end;

# ╔═╡ ed6d254b-f9da-4362-b8d7-c04ea41a63f4
bk = init_simple_span(
	width= 78ft,
	length=110ft,
	girder_type=BentTool.GirderType.Tx54,
	n_girders=9,
	spacing=[3ft, 9ft, 9ft, 8.5ft, 9ft, 9ft, 9ft, 9ft, 9ft]
);

# ╔═╡ f97ff301-178d-441b-99e2-60c7aeb28168
fd = init_simple_span(
	width= 78ft,
	length=110ft,
	girder_type=BentTool.GirderType.Tx54,
	n_girders=10,
	spacing=[4ft, 8ft, 8ft, 8ft, 8ft, 8ft, 8ft, 7.5ft, 8ft, 8ft]
);

# ╔═╡ c66a6dc6-a06e-4884-aae9-2f3bf5ac31fe
md"## Back Span"

# ╔═╡ 428c8034-6ba0-43db-9d94-6d4c7f44b028
md"""
The figure below shows the beam spacing for the backspan girders. Since Cap18 works in half-foot increments, the beam spacing was rounded to the nearest increments. Both Cap18 and Larsa have the same spacing for the beams.
"""

# ╔═╡ a280afbd-a51a-4432-a920-e78484f951bf
begin
plot(bk, title="Back Span", xlabel="Distance", ylabel="Height")
plot!(cap, y_offset=-5ft)
end

# ╔═╡ 90a642be-9e1a-4b54-8ac6-30c8cf941713
md"## Forward Span"

# ╔═╡ 7c3343a6-c872-45ac-b406-3c75d185985e
md"""
The figure below shows the beam spacing for the forwardspan girders.
"""

# ╔═╡ 04825322-03f7-4542-b760-57aa11633642
begin
plot(fd, title="Forward Span", xlabel="Distance", ylabel="Height")
plot!(cap, y_offset=-5ft)
end

# ╔═╡ 24f29d1e-cc53-4789-89c6-e0dcb32e8f25
function plot_stress(stress; kwargs...)
    plot(fd, fillalpha=0.5, ls=:dash, dims=false, xlabel="Width", ylabel="Height")
    plot!(bk)
    # plot!(fwd, fillalpha=0.5, lc=:lightgrey)
    plot!(cap, y_offset=-5ft)
    plot!( twinx(), stress, right_y=true; kwargs...)
end

# ╔═╡ 04abb342-7283-49f6-9608-250264f99805
md"# Cap 18"

# ╔═╡ b5f8889a-f436-42f0-b279-37cf14258b06
md"""
A Cap18 input file was created and ran for the above bent. The output file was then parses for the dead load, working stress, and load factor cases. The summary of the findings are discussed below.
"""

# ╔═╡ 92484c55-8872-4ef3-8de7-2e97af6977c9
trim(m::Cap18.Moments) = Cap18.Moments(m.dist[2:end-1], m.moments[2:end-1])

# ╔═╡ e3aa4715-d6ed-4cde-859d-5cd6665ffdc6
trim(m::Cap18.Shears) = Cap18.Shears(m.dist[2:end-1], m.shear[2:end-1])

# ╔═╡ 1b0c1c21-de64-42a0-97d7-6b92dfc76c4f
trim(m::Cap18.MomentEnvelopes) = Cap18.MomentEnvelopes(m.dist[2:end-1], m.max_moment[2:end-1], m.min_moment[2:end-1])

# ╔═╡ 99d0ef79-4f7e-4fba-b9ec-cbabe26ed2de
trim(m::Cap18.ShearEnvelopes) = Cap18.ShearEnvelopes(m.dist[2:end-1], m.max_shear[2:end-1], m.min_shear[2:end-1])

# ╔═╡ d5de5415-c114-472e-90c0-46a83ff22f16
md"## File Info"

# ╔═╡ 4ecfdc83-d595-40f2-9421-78f02db8cfb2
path = pwd() * "\\cap18_ex2.lis";

# ╔═╡ 89b739e6-0528-4b11-9516-4abd3a1d6375
p = parse_cap18(path);

# ╔═╡ 414d6b8e-219a-45d1-9b30-44702926b24a
md"## SRV"

# ╔═╡ fe650a1b-a08c-4e29-8df1-0859c474a295
md"""
### Dead Load Results (SRV)
The dead load results were plotted on top of the bent to get a better visual understanding of the results. Based on the DL shear and moment diagrams below, the Cap18 results look to align well with the bent. Sharp changes in shear happen in areas with either a column or a beam, and negative moments are maximized over the columns. This indicates to some degree that the expected behavior of the stresses within the cap is being captured by the Cap18 program. A more detailed comparison with Larsa results will help determine if the magnitudes of these stresses are correct.
"""

# ╔═╡ bb2a7c4d-61aa-45e5-8363-d539c5e64eed
p1_tb4a = DataFrame(p[1].tb4a.results);

# ╔═╡ 1ce7917d-80b4-470e-9b26-d9d69319bc7a
begin
	d_dc_cap18 = deflections(p[1].tb4a)
	m_dc_cap18 = moments(p[1].tb4a) |> trim
	s_dc_cap18 = shears(p[1].tb4a) |> trim
end;

# ╔═╡ 4e013dcc-6215-4c77-a759-9dbec7ad695d
plot_stress(s_dc_cap18, title = "Cap18: DL Shear", ylabel="Shear (kips)")

# ╔═╡ c626747a-d75e-4888-bcf1-ab8d16bc5bc9
plot_stress(m_dc_cap18, title = "Cap18: DL Moment", ylabel="Moment (kip-ft)")

# ╔═╡ 667a950c-c0f1-4cd2-b065-b7273803ab61
md"""
### Envelopes of Maximum Values (SRV)
The working stress results were plotted on top of the bent to get a better visual understanding of the results. The results can be seen in the figures below. These stresses follow the same expected behavoir as the DL stresses. Further comparison with Larsa is needed.
"""

# ╔═╡ 7d62095c-8c25-4b15-bcfe-8e5847f26d0a
p1_tb6 = DataFrame(p[1].tb6ws.results);

# ╔═╡ 45e6adf2-09de-4bc8-9427-1ed6aa7014f2
begin
	smax_cap18_srv = max_shears(p[1].tb6ws) |> trim
	smin_cap18_srv = min_shears(p[1].tb6ws) |> trim
	se_cap18_srv = shear_envelopes(p[1].tb6ws) |> trim
	
	mmax_cap18_srv = max_moments(p[1].tb6ws) |> trim
	mmin_cap18_srv = min_moments(p[1].tb6ws) |> trim
	me_cap18_srv = moment_envelopes(p[1].tb6ws) |> trim
end;

# ╔═╡ 07a33a27-56ba-413d-8a18-cd9f4db82717
plot_stress(se_cap18_srv, title = "Cap18: Max Shear Envelope (SRV)", ylabel="Shear (kips)")

# ╔═╡ 74af8cc2-3e66-4bb8-b3d1-79e44f5571fa
plot_stress(me_cap18_srv, title = "Cap18: Max Moment Envelope (SRV)", ylabel="Moment (kip-ft)")

# ╔═╡ 67387403-c3b1-4abb-8f39-a95fdafcd86a
md"""
### Maximum Support Reactions (SRV)
The maximum and minimum support reactions for the working stress case are listed in the table below.
"""

# ╔═╡ 6a19f29a-c868-4997-9008-f51a4a1b32a3
begin r_cap18_srv = DataFrame(p[1].tb7ws.results) end

# ╔═╡ 30b670c4-a2c3-4d73-8fc7-99130c56931a
md"## STR"

# ╔═╡ e959a15e-2f0a-4e03-8cce-562cd0b7a67a
md"""
### Envelopes of Maximum Values (STR)
The load factor results were plotted on top of the bent to get a better visual understanding of the results. The results can be seen in the figures below. These stresses follow the same expected behavoir as the DL stresses. Further comparison with Larsa is needed.
"""

# ╔═╡ 6cd85e33-9157-414f-b7c0-96c7a35d942d
p1_tb6lf = DataFrame(p[1].tb6lf.results);

# ╔═╡ aebb9c62-e82d-425f-9b93-a754d334a03e
begin
	smax_cap18_str = max_shears(p[1].tb6lf) |> trim
	smin_cap18_str = min_shears(p[1].tb6lf) |> trim
	se_cap18_str = shear_envelopes(p[1].tb6lf) |> trim
	
	mmax_cap18_str = max_moments(p[1].tb6lf) |> trim
	mmin_cap18_str = min_moments(p[1].tb6lf) |> trim
	me_cap18_str = moment_envelopes(p[1].tb6lf) |> trim
end;

# ╔═╡ e4d17177-b475-4947-9af1-055dba75bdf7
plot_stress(se_cap18_str, title = "Cap18: Max Shear Envelope (STR)", ylabel="Shear (kips)")

# ╔═╡ d0c31d06-8992-41de-a9b2-9d3be00e09a7
plot_stress(me_cap18_str, title = "Cap18: Max Moment Envelope (STR)", ylabel="Moment (kip-ft)")

# ╔═╡ 1afe7e12-013e-43c7-bda9-5af9b99a3bf7
md"""
### Maximum Support Reactions (STR)
The maximum and minimum support reactions for the load factor case are listed in the table below.
"""

# ╔═╡ c7906377-fe20-459a-a96b-f3a81902b821
begin r_cap18_str = DataFrame(p[1].tb7lf.results) end

# ╔═╡ 24a86307-2008-4ee9-8a8e-c694c6b2bc52
md"# Larsa Results"

# ╔═╡ 7b6b5e91-6bcb-4f9b-a119-96545b6590cd
md"""
A Larsa model was created and ran for the above bent. The loads were extracted for the dead load, working stress, and load factor cases. The summary of the findings are discussed below.
"""

# ╔═╡ 127266ea-bcf3-4863-abdb-e435aeabc127
function parse_larsa_moments(df)
	@chain df begin
		@clean_names
		@rename(moment_y = `moment_y_(kips_ft)`)
		@filter(member < 20000)
		# @filter(mod(member, 10000) == mod(joint, 1000))
		@mutate(moment_y = if_else(mod(member, 10000) == mod(joint, 1000),moment_y, -moment_y))
		@mutate(joint = (joint-1000)*0.5)
	    @group_by(joint)
	    @summarize(
			max_my = maximum(moment_y),
			min_my = minimum(moment_y)
		)
	    @select(joint, max_my, min_my)
		@ungroup
		Cap18.MomentEnvelopes(_.joint, _.max_my, _.min_my)
	end
end

# ╔═╡ 0b33e462-9bfe-4051-81c5-6132d4b47181
function parse_larsa_moments(df, sym)
	new_df = @chain df begin
		@clean_names
		@rename(moment_y = `moment_y_(kips_ft)`)
		@filter(member < 20000)
		# @filter(mod(member, 10000) == mod(joint, 1000))
		@mutate(moment_y = if_else(mod(member, 10000) == mod(joint, 1000),moment_y, -moment_y))
		@mutate(joint = (joint-1000)*0.5)
	    @group_by(joint)
	    @summarize(
			max_my = maximum(moment_y),
			min_my = minimum(moment_y)
		)
	    @select(joint, max_my, min_my)
		@ungroup
	end
	if sym == :maximum
		Cap18.Moments(new_df.joint, new_df.max_my)
	elseif sym == :minimum
		Cap18.Moments(new_df.joint, new_df.min_my)
	else
		error("Please enter `:maximum` or `:minimum` for sym. You entered $sym")
	end
end

# ╔═╡ 513d27d6-23b7-4eaa-ad31-c1d93c294422
function parse_larsa_shears(df)
	@chain df begin
		@clean_names
		@rename(force_z = `force_z_(kips)`)
		@filter(member < 20000)
		# @filter(mod(member, 10000) == mod(joint, 1000))
		@mutate(force_z = if_else(mod(member, 10000) == mod(joint, 1000),force_z, -force_z))
		@mutate(joint = (joint-1000)*0.5)
	    @group_by(joint)
	    @summarize(
			max_fz = maximum(force_z),
			min_fz = minimum(force_z)
		)
	    @select(joint, max_fz, min_fz)
		@ungroup
		Cap18.ShearEnvelopes(_.joint, _.max_fz, _.min_fz)
	end
end

# ╔═╡ f3ee83e5-015d-4ba2-a260-1f66465ff4af
function parse_larsa_shears(df, sym)
	new_df = @chain df begin
		@clean_names
		@rename(force_z = `force_z_(kips)`)
		@filter(member < 20000)
		# @filter(mod(member, 10000) == mod(joint, 1000))
		@mutate(force_z = if_else(mod(member, 10000) == mod(joint, 1000),force_z, -force_z))
		@mutate(joint = (joint-1000)*0.5)
	    @group_by(joint)
	    @summarize(
			max_fz = maximum(force_z),
			min_fz = minimum(force_z)
		)
	    @select(joint, max_fz, min_fz)
		@ungroup
	end
	if sym == :maximum
		Cap18.Shears(new_df.joint, new_df.max_fz)
	elseif sym == :minimum
		Cap18.Shears(new_df.joint, new_df.min_fz)
	else
		error("Please enter `:maximum` or `:minimum` for sym. You entered $sym")
	end
end

# ╔═╡ 1dc3387c-2e39-49b9-8bed-712722b9ea2b
function parse_larsa_reactions(path)
	df = dropmissing(CSV.read(path, DataFrame))
	@chain df begin
		@clean_names
		@rename(force_z = `force_z_(kips)`)
		@mutate(sta = (joint-1000))
	    @group_by(sta)
	    @summarize(
			dist = maximum((joint-1000)*0.5),
			max_reaction = maximum(force_z),
			min_reaction = minimum(force_z)
		)
	    @select(sta, dist, max_reaction, min_reaction)
		@ungroup
	end
end

# ╔═╡ 6ed56ba2-6dce-4bb9-a92e-f1b17445078a
md"## File Info"

# ╔═╡ 1e0091b1-0618-4041-938b-922913e02e66
path_dc_larsa_srv = dir *"\\dc_larsa_srv1.csv";

# ╔═╡ 1cdb03ea-43a8-4b4e-be3e-0cee9c5aa8a1
path_se_larsa_srv = dir *"\\se_larsa_srv.csv";

# ╔═╡ 8dd7e625-29e9-48f8-8e31-15468ce229d8
path_me_larsa_srv = dir *"\\me_larsa_srv.csv";

# ╔═╡ 27f08e9f-4d8a-4ca9-80d5-33a7d16d143e
path_se_larsa_str = dir *"\\se_larsa_str.csv";

# ╔═╡ 9dd6737c-e53d-46c7-b4e4-d2f3f5c90805
path_me_larsa_str = dir *"\\me_larsa_str.csv";

# ╔═╡ 2144728e-6f81-4500-af5e-32ecf977d80c
path_r_larsa_srv = dir *"\\r_larsa_srv.csv";

# ╔═╡ 0be2770e-2604-4768-b3e0-30e1d33ccb9a
path_r_larsa_str = dir *"\\r_larsa_str.csv";

# ╔═╡ f936bc54-9e76-4aa4-bf9c-c4ff72599aaa
md"## SRV"

# ╔═╡ bddc9d55-fe00-4992-b754-da5fb9728510


# ╔═╡ b5e5b84e-2645-47e1-8117-eee44c9aca41
md"""
### Dead Load Results (SRV)
The dead load results were plotted on top of the bent to get a better visual understanding of the results. Based on the DL shear and moment diagrams below, the Larsa results look to align well with the bent. Sharp changes in shear happen in areas with either a column or a beam, and negative moments are maximized over the columns. This indicates to some degree that the expected behavior of the stresses within the cap is being captured by the Cap18 program. A more detailed comparison with the Cap18 results will help determine if the magnitudes of the stresses calculated from the Cap18 program are correct.
"""

# ╔═╡ 162fcada-2e4c-45e2-898f-ae794d5b7e8c


# ╔═╡ 4d1e6dd0-536c-4f78-bfdb-ab5af8bdd57e
begin 
	df_dc_larsa_srv = dropmissing(CSV.read(path_dc_larsa_srv, DataFrame))
end;

# ╔═╡ 12ccd009-a7d8-474a-8e18-80461840ee85
begin
	m_dc_larsa = parse_larsa_moments(df_dc_larsa_srv, :maximum)
	s_dc_larsa = parse_larsa_shears(df_dc_larsa_srv, :maximum)
end;

# ╔═╡ c18e3aa3-f5ee-4cda-87da-405d843f4282
plot_stress(s_dc_larsa, title = "Larsa: DL Shear", ylabel="Shear (kips)")

# ╔═╡ f4d133f8-1d5b-4299-8463-2e714c2421bc
plot_stress(m_dc_larsa, title = "Larsa: DL Moment", ylabel="Moment (kip-ft)")

# ╔═╡ dceb089b-f387-4fd3-85f3-81915e9eb538
md"""
### Envelopes of Maximum Values (SRV)
The working stress results were plotted on top of the bent to get a better visual understanding of the results. The results can be seen in the figures below. These stresses follow the same expected behavoir as the DL stresses. Further comparison with Cap18 is needed.
"""

# ╔═╡ fd517f0a-5b1c-4a8f-829b-847c79e3847b
begin 
	df_se_larsa_srv = dropmissing(CSV.read(path_se_larsa_srv, DataFrame))
	df_me_larsa_srv = dropmissing(CSV.read(path_me_larsa_srv, DataFrame))
end;

# ╔═╡ b70f2151-ae0c-4e44-b8d0-e82eaccd3e60
begin
	#shears
	smax_larsa_srv = parse_larsa_shears(df_se_larsa_srv, :maximum)
	smin_larsa_srv = parse_larsa_shears(df_se_larsa_srv, :minimum)
	se_larsa_srv = parse_larsa_shears(df_se_larsa_srv)

	# moments
	mmax_larsa_srv = parse_larsa_moments(df_me_larsa_srv, :maximum)
	mmin_larsa_srv = parse_larsa_moments(df_me_larsa_srv, :minimum)
	me_larsa_srv = parse_larsa_moments(df_me_larsa_srv)
end;

# ╔═╡ 868fff2d-023b-4a0e-ae91-a7c1866edc84
begin
	plot(
		plot(se_larsa_srv, title="Max Shear Envelope (SRV)"),
		plot(me_larsa_srv, title="Max Moment Envelope (SRV)"), 
		layout = (2, 1),
		legend = :outerbottom,
		legend_column = -1
	)
end;

# ╔═╡ 6a02ac50-e7ff-450e-84c2-e2797dcb9eea
plot_stress(se_larsa_srv, title = "Larsa: Max Shear Envelope (SRV)", ylabel="Shear (kips)")

# ╔═╡ ba0ed562-5a4c-4c35-8b9d-0a790fd6848b
plot_stress(me_larsa_srv, title = "Larsa: Max Moment Envelope (SRV)", ylabel="Moment (kip-ft)")

# ╔═╡ 0be5f3c4-7b06-4b6f-9ebd-6bfc8e7eabcf
md"""
### Maximum Support Reactions (SRV)
The maximum and minimum support reactions for the working stress case are listed in the table below.
"""

# ╔═╡ 0fb7d82a-b3cf-49e1-9f75-d6f2b6589988
begin r_larsa_srv = parse_larsa_reactions(path_r_larsa_srv) end

# ╔═╡ 957b773e-bf67-4ebf-b36b-9c107d48495e
md"## STR"

# ╔═╡ 92e02ef7-c243-41e0-bf78-e8a14b4b19b6
md"""
### Envelopes of Maximum Values (STR)
The load factor results were plotted on top of the bent to get a better visual understanding of the results. The results can be seen in the figures below. These stresses follow the same expected behavoir as the DL stresses. Further comparison with Cap18 is needed.
"""

# ╔═╡ 8b87da65-538c-4ae8-8f9a-3473b064928f
begin 
	df_se_larsa_str = dropmissing(CSV.read(path_se_larsa_str, DataFrame))
	df_me_larsa_str = dropmissing(CSV.read(path_me_larsa_str, DataFrame))
end;

# ╔═╡ 1819576b-3d29-4853-9912-b2237bd6b1ba
begin
	#shears
	smax_larsa_str = parse_larsa_shears(df_se_larsa_str, :maximum)
	smin_larsa_str = parse_larsa_shears(df_se_larsa_str, :minimum)
	se_larsa_str = parse_larsa_shears(df_se_larsa_str)

	# moments
	mmax_larsa_str = parse_larsa_moments(df_me_larsa_str, :maximum)
	mmin_larsa_str = parse_larsa_moments(df_me_larsa_str, :minimum)
	me_larsa_str = parse_larsa_moments(df_me_larsa_str)
end;

# ╔═╡ d47b401a-01bf-4868-83d0-1b4837ca9c2a
begin
		plot(
		plot(se_larsa_str, title="Max Shear Envelope (STR)"),
		plot(me_larsa_str, title="Max Moment Envelope (STR)"), 
		layout = (2, 1),
			legend = legend_pos,
		size = (x_size, y_size)
	)
end;

# ╔═╡ 91cf119b-046d-4deb-972e-78d6e1f80add
plot_stress(se_larsa_str, title = "Larsa: Max Shear Envelope (STR)", ylabel="Shear (kips)")

# ╔═╡ a30dd220-00a8-43f4-b5cc-e1550053338a
plot_stress(me_larsa_str, title = "Larsa: Max Moment Envelope (STR)", ylabel="Moment (kip-ft)")

# ╔═╡ 29649a5f-f15c-4fa1-84d7-c89964abfd27
md"""
### Maximum Support Reactions (STR)
The maximum and minimum support reactions for the load factor case are listed in the table below.
"""

# ╔═╡ 881cdc5a-032e-4edd-9ea3-1080526f0b75
begin r_larsa_str = parse_larsa_reactions(path_r_larsa_str) end

# ╔═╡ e665f551-e7d8-4b6b-9983-abfe4f61d452
md"""
# Comparison
Below is a comparison of the Cap18 and Larsa results. Stresses were found to be fairly similar between the different programs. The main differences are in the shear stresses. Cap18 seems to have a more gradual change in shear compared to Larsa. This is most likely due to the way Cap18 defines the point loads in the program. This gradual vs more sharp change in shear does not seem to affect the moment diagram in a significant way. Moment diagram stresses do show some differences and will be discussed in more detail below.

**Important Plot Information**\
The comparison plots for the shear and moment diagrams are shown below for all the different load cases. The Cap18 results are shown in a blue line and the larsa results are shown in a red line. The red line will only really be visible when the larsa results are greater in magnitude than the cap18 results. The thickness of the red or blue line shows how much greater in magnitdue the respective result was. The absolute difference between larsa and cap18 is show in yellow. Any positive yellow results indicate that larsa was greater in magnitude.
"""

# ╔═╡ 1a41075d-8fe7-48cb-98ae-fd793c41f856
function plot_cap(; kwargs...)
		plt = plot(fd, fillalpha=0.5, ls=:dash, dims=false, ylabel="Height", xlabel="Distance", label="")
		plot!(bk,  label="")
		# plot!(fwd, fillalpha=0.5, lc=:lightgrey)
		plot!(cap, y_offset=-5ft,  label="")
		plt
	end

# ╔═╡ 69dacdaa-4285-4d4d-bc0d-6c304500289e
function plot_shear_comparison(s_cap18, s_larsa; title="Shear Comparison", fillalpha=0.5, base_color=:grey)
		min_val = [abs(cap) <= abs(larsa) ? cap : larsa for (cap, larsa) in zip(s_cap18.shear, s_larsa.shear) ]
	
		cap18_color = :blue
		# cap_plt = plot_cap()
		shear_plt = plot(s_cap18, fillcolor=base_color, lc=cap18_color, label="", fillalpha=fillalpha)
	
		plot!(s_larsa, label="S larsa", fillalpha=1, fillcolor=:red, fillrange=min_val, lc=:red)
	
		plot!(s_cap18, fillcolor=cap18_color, lc=cap18_color, label="S cap18", fillalpha=1, fillrange=min_val)
	
		plot!(abs(s_larsa) - abs(s_cap18),
			fillalpha=1, fillcolor=:orange, lc=:black, label="S diff",
			title = title,
			right_y=true,
			ylabel="Shear (kips)",
		)

		shear_plt
	end

# ╔═╡ 5f20f501-51a8-4d3b-8e56-588d3b7afd84
begin

	function plot_local_humps(m_cap18::Cap18.Moments, m_larsa::Cap18.Moments; subplot=1, text_pos=:right, text_size=6)
	
	
		max_val = [abs(cap) >= abs(larsa) ? cap : larsa for (cap, larsa) in zip(m_cap18.moments, m_larsa.moments) ]
		
	    y = max_val
		x = m_cap18.dist
		
		local_extrema = []
		extrema_x = []
		index = Int[]
	    for i in 2:length(y)-1
	        if y[i] > y[i-1] && y[i] > y[i+1]
				if abs(y[i]) > 10
	            	push!(local_extrema, y[i])
					push!(extrema_x, x[i])
					push!(index, i)
				end
	        elseif y[i] < y[i-1] && y[i] < y[i+1]
	            if abs(y[i]) > 10
	            	push!(local_extrema, y[i])
					push!(extrema_x, x[i])
					push!(index, i)
				end
	        end
	    end
	
		m = m_cap18 - m_larsa
		m_abs = abs(m_larsa) - abs(m_cap18)
		m_percent = m/m_cap18
		text_color = [m_abs.moments[i] > 0 ? :red : :blue for i in index]
		
		d = [m_percent.moments[i] for i in index]*100
		annos = [text("($(round(_y, digits=2)), $(round(_d, digits=2))%)", text_size, text_pos, "Arial Black", tc) for (_y, _d, tc) in zip(local_extrema, d, text_color)]
	
		scatter!(extrema_x,local_extrema, subplot=subplot, markersize=2, label="")
		annotate!(extrema_x, local_extrema, annos, subplot=subplot)
	end
	
	function plot_comparison(s_cap18, s_larsa, m_cap18, m_larsa; 
	    legend_pos=legend_pos,
	    size = (x_size, y_size), 
	    shear_title="Shear Comparison", 
	    moment_title="Moment Comparison",
	    shear_alpha=0.5,
	    moment_alpha=0.5,
	    base_color=:grey,
		kwargs...
	    )
	        
	    shear_plt = plot_shear_comparison(s_cap18, s_larsa, title=shear_title, fillalpha=shear_alpha, base_color=base_color)
	        
	    moment_plt = plot_moment_comparison(m_cap18, m_larsa, title=moment_title, fillalpha=moment_alpha, base_color=base_color, kwargs...)
	            
	    plot(
	        shear_plt,
	        moment_plt,
	        layout = (2, 1),
	        legend = legend_pos,
	        size = size,
	        plot_size=size
	    )
	
	end

	
	function plot_env_comparison(se_cap18_srv, se_larsa_srv, me_cap18_srv, me_larsa_srv; legend_pos=legend_pos, size = (x_size, y_size))
		shear_plt = plot(se_cap18_srv, maxlabel="+V cap18", minlabel="-V cap18")
		plot!(se_larsa_srv, lc=:black, maxlabel="+V larsa", minlabel="-V larsa")
		plot!(se_cap18_srv - se_larsa_srv, 
			fillalpha=1, maxcolor=:red, mincolor=:blue, lc=:black,
			maxlabel="+V diff", minlabel="-V diff",
			title="Shear Envelope Comparison"
		)
	
		moment_plt = plot(me_cap18_srv, maxlabel="+M cap18", minlabel="-M cap18")
		plot!(me_larsa_srv, lc=:black, maxlabel="+M larsa", minlabel="-M larsa")
		plot!(me_cap18_srv - me_larsa_srv, 
			fillalpha=1, maxcolor=:red, mincolor=:blue, lc=:black,
			maxlabel="+M diff", minlabel="-M diff",
			title="Moment Envelope Comparison"
		)
		
		plot(
			shear_plt,
			moment_plt,
			layout = (2, 1), 
			legend = legend_pos,
			size = size,
			plot_size=(600, 400)
		)
	end
	
	function plot_max_comparison(se_cap18_srv, se_larsa_srv, me_cap18_srv, me_larsa_srv; legend_pos=legend_pos, size = (x_size, y_size), base_color=:grey, kwargs...)
		s_cap18 = max_shears(se_cap18_srv)
		s_larsa = max_shears(se_larsa_srv)
	
		m_cap18 = max_moments(me_cap18_srv)
		m_larsa = max_moments(me_larsa_srv)
		plot_comparison(s_cap18, s_larsa, m_cap18, m_larsa; legend_pos=legend_pos, size = size, base_color=base_color, kwargs...)

	end
	
	function plot_min_comparison(se_cap18_srv, se_larsa_srv, me_cap18_srv, me_larsa_srv; legend_pos=legend_pos, size = (x_size, y_size), base_color=:grey, kwargs...)
		s_cap18 = min_shears(se_cap18_srv)
		s_larsa = min_shears(se_larsa_srv)
	
		m_cap18 = min_moments(me_cap18_srv)
		m_larsa = min_moments(me_larsa_srv)
		plot_comparison(s_cap18, s_larsa, m_cap18, m_larsa; legend_pos=legend_pos, size = size, base_color=base_color, kwargs...)
	end

	function plot_moment_annotations(m_original::Cap18.Moments, m_new::Cap18.Moments; subplot=1, text_color=:blue, text_pos=:right, text_size=6)
		m = m_original - m_new
		m_percent = m/m_original
		mmax, max_idx = findmax(m.moments)
		mmin, min_idx = findmin(m.moments)
	
		x = [m.dist[max_idx], m.dist[min_idx]]
		y = [mmax, mmin]
		d = [m_percent.moments[max_idx], m_percent.moments[min_idx]]*100
		
		annos = [text("($(round(_y, digits=2)), $(round(_d, digits=2))%)", text_size, text_pos, "Arial Black", text_color) for (_y, _d) in zip(y, d)]
	
		x, y, annos
	
		scatter!(x,y, subplot=subplot, markersize=2, label="")
		annotate!(x, y, annos, subplot=subplot)
	end
	
	function plot_difference(
		s_cap18, s_larsa, m_cap18, m_larsa;
		shear_title="Shear Difference",
		moment_title="Moment Difference",
		fillcolor=:blue,
		kwargs...
	)
		shear_plt = plot(s_cap18 - s_larsa, title = shear_title, ylabel="Shear (kips)", xlabel="Distance (ft)", label="S diff", fillcolor=fillcolor, lc=fillcolor)
		moment_plt = plot(m_cap18 - m_larsa, title = moment_title, ylabel="Moment (kip-ft)",  xlabel="Distance (ft)", label="M diff", fillcolor=fillcolor, lc=fillcolor)
	
		plot(
				shear_plt,
				moment_plt,
				layout = (2, 1),
				legend = legend_pos,
				size = (x_size, y_size)
		)
		plot_moment_annotations(m_cap18, m_larsa; subplot=2)
	end
	
	function plot_max_ll_comparison(
	    se_cap18, se_larsa, 
	    me_cap18, me_larsa, 
	    s_dc_cap18, s_dc_larsa,
	    m_dc_cap18, m_dc_larsa; 
	    kwargs...)
	
	    ll_se_cap18 = max_shears(se_cap18) - s_dc_cap18
	    ll_se_larsa = max_shears(se_larsa) - s_dc_larsa
	
	    ll_me_cap18 = max_moments(me_cap18) - m_dc_cap18
	    ll_me_larsa = max_moments(me_larsa) - m_dc_larsa
	    
	    plot_comparison(ll_se_cap18, ll_se_larsa, ll_me_cap18, ll_me_larsa; kwargs...)
	end
	
	function plot_min_ll_comparison(
	    se_cap18, se_larsa, 
	    me_cap18, me_larsa, 
	    s_dc_cap18, s_dc_larsa,
	    m_dc_cap18, m_dc_larsa; 
	    kwargs...)
	
	    ll_se_cap18 = min_shears(se_cap18) - s_dc_cap18
	    ll_se_larsa = min_shears(se_larsa) - s_dc_larsa
	
	    ll_me_cap18 = min_moments(me_cap18) - m_dc_cap18
	    ll_me_larsa = min_moments(me_larsa) - m_dc_larsa
	    
	    plot_comparison(ll_se_cap18, ll_se_larsa, ll_me_cap18, ll_me_larsa; kwargs...)
	end
end

# ╔═╡ 717893d3-c334-4d1c-a8a2-f05d81ebceb8
function plot_moment_comparison(m_cap18, m_larsa; title="Moment Comparison", fillalpha=0.5, base_color=:grey, plot_annos=true)
		min_val = [abs(cap) <= abs(larsa) ? cap : larsa for (cap, larsa) in zip(m_cap18.moments, m_larsa.moments) ]
	
		cap18_color = :blue
	
		# cap_plt = plot_cap()
	
		moment_plt = plot(m_cap18, fillcolor=base_color, lc=cap18_color, label="", fillalpha=fillalpha)
		plot!(m_larsa, label="M larsa", fillalpha=1, fillcolor=:red, fillrange=min_val, lc=:red)
		plot!(m_cap18, fillcolor=cap18_color, lc=cap18_color, label="M cap18", fillalpha=1, fillrange=min_val)
		plot!(abs(m_larsa) - abs(m_cap18), 
			fillalpha=1, fillcolor=:orange, lc=:black, label="M diff",
			title = title,
			ylabel="Moment (kip-ft)",
			xlabel="Distance (ft)"
		)
		if plot_annos
			plot_local_humps(m_cap18, m_larsa)
		end
		moment_plt
	end

# ╔═╡ 07a726ea-2c03-4df6-a62c-a3f6f57fe1ba
md"## SRV"

# ╔═╡ 354ab70e-1745-4218-9809-31767ad15801
md"### Dead Load Results (SRV)"

# ╔═╡ 0f981aea-09af-4088-8dd1-5cfce76696fe
md"""
The figures below compare the DL results between the two programs. The areas in red highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 2%.
"""

# ╔═╡ 5801ccdc-3aab-4bc3-a4d2-50e2a92db10a
gr()

# ╔═╡ 10bebb7e-b9e3-4bd6-8af8-bf3e7bba2d1d
plot_comparison(
	s_dc_cap18, s_dc_larsa, m_dc_cap18, m_dc_larsa; 
	legend_pos=legend_pos, 
	size = (x_size, y_size),
	shear_alpha=0.5,
	moment_alpha=0.5,
	shear_title="DL Shear Comparison",
	moment_title="DL Moment Comparison",
	base_color=:blue
)

# ╔═╡ 3e34c8ba-5ba7-4fc9-8aed-047b2648a4ac
begin
plot_difference(
	s_dc_cap18, s_dc_larsa, m_dc_cap18, m_dc_larsa,
	shear_title= "DL Shear Difference",
	moment_title= "DL Moment Difference",
	fillcolor=:blue
)
end

# ╔═╡ 4827d427-6e6d-4d94-8cdf-2874cd243f07
_x = m_dc_cap18.dist[122]

# ╔═╡ d713e5e4-bf0f-49af-95d6-370b80e539d7
_d = round(((m_dc_cap18-m_dc_larsa)/m_dc_cap18).moments[122]*100, digits=2)

# ╔═╡ 2f22d01d-fc9a-4e18-9add-d667cc500563
_y = round((m_dc_cap18-m_dc_larsa).moments[122], digits=2)

# ╔═╡ fe01028a-2a19-44e4-a1c7-1ce8e52d79c2
plot_stress(m_dc_cap18-m_dc_larsa, title = "Cap18: DL Shear Difference", ylabel="Shear (kips)");

# ╔═╡ 4495b6cf-b9f0-4cfb-b6b0-72d6a3e8fa98
md"### Envelopes of Maximum Values (SRV)"

# ╔═╡ 7b1be9dd-5424-4d5b-8057-c334d22b8ec3
md"#### Maximum Envelope Comparison"

# ╔═╡ ac120f37-7e33-43f4-ac9d-4c72ed758703
md"""
The figures below compare the working stress results for the maximum stress envelope between the two programs. The areas in red highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ 878fdfe9-28e9-4c9c-82e0-7409e5d28c80
plot_max_comparison(se_cap18_srv, se_larsa_srv, me_cap18_srv, me_larsa_srv, 
	legend_pos=legend_pos, 
	size=(x_size, y_size),
	base_color=:blue,
	shear_title="Max Envelope Shear Comparison (SRV)",
	moment_title="Max Envelope Moment Comparison (SRV)",
)

# ╔═╡ ffcd9a68-c6d7-4b0c-a237-acfa7ec526df
plot_difference(
	max_shears(se_cap18_srv), max_shears(se_larsa_srv), max_moments(me_cap18_srv), max_moments(me_larsa_srv),
	shear_title= "Shear Envelope Difference",
	moment_title= "Moment Envelope Difference",
)

# ╔═╡ e64c2f8c-d83d-41c8-b125-ae911d01b341
md"#### Minimum Envelope Comparison"

# ╔═╡ c6a27711-c67d-41a0-9b87-8d953c91ef0a
md"""
The figures below compare the working stress results for the minimum stress envelope between the two programs. The areas in red (not the light red areas) highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. . In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ 8e7de4cd-701e-4150-b43e-2760b92f54e5
plot_min_comparison(se_cap18_srv, se_larsa_srv, me_cap18_srv, me_larsa_srv, 
	legend_pos=legend_pos, 
	size=(x_size, y_size),
	base_color=:red,
	shear_title="Min Envelope Shear Comparison",
	moment_title="Min Envelope Moment Comparison",
)

# ╔═╡ 57370204-e7f0-4bf2-a73c-f1c40b73e20b
plot_difference(
	min_shears(se_cap18_srv), min_shears(se_larsa_srv), min_moments(me_cap18_srv), min_moments(me_larsa_srv),
	shear_title= "Shear Envelope Difference",
	moment_title= "Moment Envelope Difference",
	fillcolor=:red
)

# ╔═╡ 4e3d5d79-d252-47bd-8c14-c82f214741c1
md"### Live Load Comparison (SRV)"

# ╔═╡ 79e38641-4892-4f8b-9247-c06a062a3c4f
md"""
The figures below compare the working stress results for the maximum stress envelope of the live load between the two programs. The areas in red highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ f18fe47c-d5b0-4cbe-bfa9-35a3a2573a48
	
plot_max_ll_comparison(
	se_cap18_srv, se_larsa_srv, 
	me_cap18_srv, me_larsa_srv, 
	s_dc_cap18, s_dc_larsa,
	m_dc_cap18, m_dc_larsa; 
	shear_title="Max LL Shear Comparison (SRV)",
	moment_title="Max LL Moment Comparison (SRV)",
	base_color=:blue
)

# ╔═╡ 3f54f798-c46e-48d5-8640-460d4d542e33
md"""
The figures below compare the working stress results for the minimum stress envelope of the live load between the two programs. The areas in red (not the light red areas) highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ 815abcfa-d289-4c99-9ddf-000a1683e591
		
plot_min_ll_comparison(
	se_cap18_srv, se_larsa_srv, 
	me_cap18_srv, me_larsa_srv, 
	s_dc_cap18, s_dc_larsa,
	m_dc_cap18, m_dc_larsa; 
	shear_title="Min LL Shear Comparison (SRV)",
	moment_title="Min LL Moment Comparison (SRV)",
	base_color=:red
)

# ╔═╡ b868885f-91bd-4aa7-b2fa-e8c5bcad7d8c
md"### Maximum Support Reactions (SRV)"

# ╔═╡ 06f0a804-250c-4349-a71e-fc2a3bea6668
md"""
The figure below compares the working stress results for the maximum and minimum reactions between the two programs. The results between programs are within 1% of eachother.
"""

# ╔═╡ 683d3475-6a34-466d-8442-a1fea40bd96d
begin
	let
	num_supports = length(r_cap18_srv.max_reaction)
	ctg = repeat(["Cap18 Reactions", "Larsa Reactions"], inner = num_supports)
	nam = repeat("Support " .* string.(1:num_supports), outer = 2)
	plt1 = stats.groupedbar(nam, hcat(r_cap18_srv.max_reaction, r_larsa_srv.max_reaction), 
		bar_position = :dodge, bar_width=0.7, group=ctg, title = title="Max Reactions",
			)
	plt2 = stats.groupedbar(nam, hcat(r_cap18_srv.min_reaction, r_larsa_srv.min_reaction), 
		bar_position = :dodge, bar_width=0.7, group=ctg, title="Min Reactions",
			)

		plot(plt1, plt2, layout=(2, 1), legend=legend_pos, size=(x_size, 400))
	end
end

# ╔═╡ 53823bdc-72c8-4f1e-8dcd-ff24980a54f1
md"## STR"

# ╔═╡ 9080f415-be7b-4407-b075-2fc9b038cdc5
md"### Envelopes of Maximum Values (STR)"

# ╔═╡ 04c0830f-0eaf-4783-8482-799436912d6b
md"""
The figures below compare the load factor results for the maximum stress envelope between the two programs. The areas in red highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ a26fec71-b00a-4314-a3e7-18ceadb0d26a
plot_max_comparison(se_cap18_str, se_larsa_str, me_cap18_str, me_larsa_str, 
	legend_pos=legend_pos, 
	size=(x_size, y_size),
	base_color=:blue,
	shear_title="Max Envelope Shear Comparison (STR)",
	moment_title="Max Envelope Moment Comparison (STR)",
)

# ╔═╡ 96c7edd1-f186-40c3-acd3-76a875dcbc2b
plot_difference(
	max_shears(se_cap18_str), max_shears(se_larsa_str), max_moments(me_cap18_str), max_moments(me_larsa_str),
	shear_title= "Shear Envelope Difference",
	moment_title= "Moment Envelope Difference",
)

# ╔═╡ fd2ab226-c7ce-4ba9-a6a5-c4e77d3fec82
md"""
The figures below compare the load factor results for the minimum stress envelope between the two programs. The areas in red (not the light red areas) highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. . In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ 4e96d677-7711-41fa-a9c7-5505ac0fbca8
plot_min_comparison(se_cap18_str, se_larsa_str, me_cap18_str, me_larsa_str, 
	legend_pos=legend_pos, 
	size=(x_size, y_size),
	base_color=:red,
	shear_title="Min Envelope Shear Comparison (STR)",
	moment_title="Min Envelope Moment Comparison (STR)",
)

# ╔═╡ 15327498-c1f2-45da-bca6-a6f1dac38737
plot_difference(
	min_shears(se_cap18_str), min_shears(se_larsa_str), min_moments(me_cap18_str), min_moments(me_larsa_str),
	shear_title= "Shear Envelope Difference",
	moment_title= "Moment Envelope Difference",
	fillcolor=:red
)

# ╔═╡ a783043c-edda-4740-81ee-efedd07a4ce2
md"### Live Load Comparison (STR)"

# ╔═╡ fba42007-d782-4548-80c2-837288231b4c
md"""
The figures below compare the load factor results for the maximum stress envelope of the live load between the two programs. The areas in red highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ 612f45db-f803-4f96-a837-d1edd865483d
begin
	
	max_ll_m_cap18_srv = max_moments(me_cap18_srv) - m_dc_cap18
	min_ll_m_cap18_srv = min_moments(me_cap18_srv) - m_dc_cap18
	max_ll_m_larsa_srv = max_moments(me_larsa_srv) - m_dc_larsa
	min_ll_m_larsa_srv = min_moments(me_larsa_srv) - m_dc_larsa
			
	plot_max_ll_comparison(
	    se_cap18_str, se_larsa_str, 
	    me_cap18_str, me_larsa_str, 
	    s_dc_cap18, s_dc_larsa,
	    m_dc_cap18, m_dc_larsa; 
	    shear_title="Max LL Shear Comparison (STR)",
		moment_title="Max LL Moment Comparison (STR)",
		base_color=:blue
	)
	
end

# ╔═╡ e1c6daac-9b44-48f8-84eb-46a84a788da4
md"""
The figures below compare load factor results for the minimum stress envelope of the live load between the two programs. The areas in red (not the light red areas) highlight where larsa results were greater in magnitude than the cap18 results. There are some visible red areas in the shear diagram. However, these can be explained by the difference in point load modeling between the two programs. The maximum values are shown to be very similar. In areas of maximum moment and shears, the results are within 3%.
"""

# ╔═╡ f7316707-8cff-479e-b709-cba78c500f76
plot_min_ll_comparison(
	    se_cap18_str, se_larsa_str, 
	    me_cap18_str, me_larsa_str, 
	    s_dc_cap18, s_dc_larsa,
	    m_dc_cap18, m_dc_larsa; 
	    shear_title="Max LL Shear Comparison (STR)",
		moment_title="Max LL Moment Comparison (STR)",
		base_color=:red
	)

# ╔═╡ af7f8c50-b16d-4abd-85e5-47b7953c3a1c
md"### Maximum Support Reactions (STR)"

# ╔═╡ 5412a106-25e1-4b56-bb81-753199c800f7
md"""
The figure below compares the load factor results for the maximum and minimum reactions between the two programs. The results between programs are within 5% of eachother.
"""

# ╔═╡ d06ea18b-64ea-4312-ae93-84eafc27f705
begin
	let
	num_supports = length(r_cap18_str.max_reaction)
	ctg = repeat(["Cap18 Reactions", "Larsa Reactions"], inner = num_supports)
	nam = repeat("Support " .* string.(1:num_supports), outer = 2)
	plt1 = stats.groupedbar(nam, hcat(r_cap18_str.max_reaction, r_larsa_str.max_reaction), 
		bar_position = :dodge, bar_width=0.7, group=ctg, title = title="Max Reactions",
			)
	plt2 = stats.groupedbar(nam, hcat(r_cap18_str.min_reaction, r_larsa_str.min_reaction), 
		bar_position = :dodge, bar_width=0.7, group=ctg, title="Min Reactions",
			)

		plot(plt1, plt2, layout=(2, 1), legend=legend_pos, size=(x_size, 400))
	end
end

# ╔═╡ d7436990-d916-4a3c-a018-8a9ee7c79ab5
sum(r_cap18_str.max_reaction)

# ╔═╡ b435809f-9cdf-4694-8194-585f02279c13
sum(r_larsa_str.max_reaction)

# ╔═╡ Cell order:
# ╟─649dac4c-c164-48f5-9fb9-ca12050f15c3
# ╠═19350050-6259-11ef-08a2-45f6e65cb86d
# ╠═4a04e883-3b3a-45ee-9cc2-14dbf982ea80
# ╠═24457ac2-d608-440b-9c48-6510717b6fb7
# ╠═c7bb8e6e-64fd-4cd6-b4ea-15883b9ce5ce
# ╠═a3fc2e85-ef06-4a1b-b3ba-06c8b1ac82d1
# ╟─8d1bdea9-9449-4b02-9476-a56da73cdbc4
# ╟─5e45710b-70ec-4753-accb-f5c34488da5e
# ╠═bc70b875-ad7a-4db9-b0cc-c3c05f6f7be1
# ╠═ed6d254b-f9da-4362-b8d7-c04ea41a63f4
# ╠═f97ff301-178d-441b-99e2-60c7aeb28168
# ╟─c66a6dc6-a06e-4884-aae9-2f3bf5ac31fe
# ╠═428c8034-6ba0-43db-9d94-6d4c7f44b028
# ╠═a280afbd-a51a-4432-a920-e78484f951bf
# ╟─90a642be-9e1a-4b54-8ac6-30c8cf941713
# ╟─7c3343a6-c872-45ac-b406-3c75d185985e
# ╟─04825322-03f7-4542-b760-57aa11633642
# ╠═24f29d1e-cc53-4789-89c6-e0dcb32e8f25
# ╟─04abb342-7283-49f6-9608-250264f99805
# ╟─b5f8889a-f436-42f0-b279-37cf14258b06
# ╟─92484c55-8872-4ef3-8de7-2e97af6977c9
# ╟─e3aa4715-d6ed-4cde-859d-5cd6665ffdc6
# ╟─1b0c1c21-de64-42a0-97d7-6b92dfc76c4f
# ╟─99d0ef79-4f7e-4fba-b9ec-cbabe26ed2de
# ╟─d5de5415-c114-472e-90c0-46a83ff22f16
# ╠═4ecfdc83-d595-40f2-9421-78f02db8cfb2
# ╠═89b739e6-0528-4b11-9516-4abd3a1d6375
# ╟─414d6b8e-219a-45d1-9b30-44702926b24a
# ╟─fe650a1b-a08c-4e29-8df1-0859c474a295
# ╠═bb2a7c4d-61aa-45e5-8363-d539c5e64eed
# ╠═1ce7917d-80b4-470e-9b26-d9d69319bc7a
# ╠═4e013dcc-6215-4c77-a759-9dbec7ad695d
# ╠═c626747a-d75e-4888-bcf1-ab8d16bc5bc9
# ╟─667a950c-c0f1-4cd2-b065-b7273803ab61
# ╠═7d62095c-8c25-4b15-bcfe-8e5847f26d0a
# ╠═45e6adf2-09de-4bc8-9427-1ed6aa7014f2
# ╠═07a33a27-56ba-413d-8a18-cd9f4db82717
# ╠═74af8cc2-3e66-4bb8-b3d1-79e44f5571fa
# ╠═67387403-c3b1-4abb-8f39-a95fdafcd86a
# ╟─6a19f29a-c868-4997-9008-f51a4a1b32a3
# ╟─30b670c4-a2c3-4d73-8fc7-99130c56931a
# ╟─e959a15e-2f0a-4e03-8cce-562cd0b7a67a
# ╠═6cd85e33-9157-414f-b7c0-96c7a35d942d
# ╠═aebb9c62-e82d-425f-9b93-a754d334a03e
# ╠═e4d17177-b475-4947-9af1-055dba75bdf7
# ╠═d0c31d06-8992-41de-a9b2-9d3be00e09a7
# ╟─1afe7e12-013e-43c7-bda9-5af9b99a3bf7
# ╟─c7906377-fe20-459a-a96b-f3a81902b821
# ╟─24a86307-2008-4ee9-8a8e-c694c6b2bc52
# ╟─7b6b5e91-6bcb-4f9b-a119-96545b6590cd
# ╟─127266ea-bcf3-4863-abdb-e435aeabc127
# ╟─0b33e462-9bfe-4051-81c5-6132d4b47181
# ╟─513d27d6-23b7-4eaa-ad31-c1d93c294422
# ╟─f3ee83e5-015d-4ba2-a260-1f66465ff4af
# ╟─1dc3387c-2e39-49b9-8bed-712722b9ea2b
# ╟─6ed56ba2-6dce-4bb9-a92e-f1b17445078a
# ╠═1e0091b1-0618-4041-938b-922913e02e66
# ╠═1cdb03ea-43a8-4b4e-be3e-0cee9c5aa8a1
# ╠═8dd7e625-29e9-48f8-8e31-15468ce229d8
# ╠═27f08e9f-4d8a-4ca9-80d5-33a7d16d143e
# ╠═9dd6737c-e53d-46c7-b4e4-d2f3f5c90805
# ╠═2144728e-6f81-4500-af5e-32ecf977d80c
# ╠═0be2770e-2604-4768-b3e0-30e1d33ccb9a
# ╟─f936bc54-9e76-4aa4-bf9c-c4ff72599aaa
# ╠═bddc9d55-fe00-4992-b754-da5fb9728510
# ╟─b5e5b84e-2645-47e1-8117-eee44c9aca41
# ╠═162fcada-2e4c-45e2-898f-ae794d5b7e8c
# ╠═4d1e6dd0-536c-4f78-bfdb-ab5af8bdd57e
# ╠═12ccd009-a7d8-474a-8e18-80461840ee85
# ╠═c18e3aa3-f5ee-4cda-87da-405d843f4282
# ╠═f4d133f8-1d5b-4299-8463-2e714c2421bc
# ╠═dceb089b-f387-4fd3-85f3-81915e9eb538
# ╠═fd517f0a-5b1c-4a8f-829b-847c79e3847b
# ╠═b70f2151-ae0c-4e44-b8d0-e82eaccd3e60
# ╠═868fff2d-023b-4a0e-ae91-a7c1866edc84
# ╠═6a02ac50-e7ff-450e-84c2-e2797dcb9eea
# ╠═ba0ed562-5a4c-4c35-8b9d-0a790fd6848b
# ╠═0be5f3c4-7b06-4b6f-9ebd-6bfc8e7eabcf
# ╟─0fb7d82a-b3cf-49e1-9f75-d6f2b6589988
# ╟─957b773e-bf67-4ebf-b36b-9c107d48495e
# ╠═92e02ef7-c243-41e0-bf78-e8a14b4b19b6
# ╠═8b87da65-538c-4ae8-8f9a-3473b064928f
# ╠═1819576b-3d29-4853-9912-b2237bd6b1ba
# ╠═d47b401a-01bf-4868-83d0-1b4837ca9c2a
# ╠═91cf119b-046d-4deb-972e-78d6e1f80add
# ╠═a30dd220-00a8-43f4-b5cc-e1550053338a
# ╟─29649a5f-f15c-4fa1-84d7-c89964abfd27
# ╠═881cdc5a-032e-4edd-9ea3-1080526f0b75
# ╟─e665f551-e7d8-4b6b-9983-abfe4f61d452
# ╠═1a41075d-8fe7-48cb-98ae-fd793c41f856
# ╠═69dacdaa-4285-4d4d-bc0d-6c304500289e
# ╠═717893d3-c334-4d1c-a8a2-f05d81ebceb8
# ╠═5f20f501-51a8-4d3b-8e56-588d3b7afd84
# ╟─07a726ea-2c03-4df6-a62c-a3f6f57fe1ba
# ╠═354ab70e-1745-4218-9809-31767ad15801
# ╟─0f981aea-09af-4088-8dd1-5cfce76696fe
# ╠═5801ccdc-3aab-4bc3-a4d2-50e2a92db10a
# ╠═10bebb7e-b9e3-4bd6-8af8-bf3e7bba2d1d
# ╠═3e34c8ba-5ba7-4fc9-8aed-047b2648a4ac
# ╠═4827d427-6e6d-4d94-8cdf-2874cd243f07
# ╠═d713e5e4-bf0f-49af-95d6-370b80e539d7
# ╠═2f22d01d-fc9a-4e18-9add-d667cc500563
# ╠═fe01028a-2a19-44e4-a1c7-1ce8e52d79c2
# ╟─4495b6cf-b9f0-4cfb-b6b0-72d6a3e8fa98
# ╟─7b1be9dd-5424-4d5b-8057-c334d22b8ec3
# ╟─ac120f37-7e33-43f4-ac9d-4c72ed758703
# ╟─878fdfe9-28e9-4c9c-82e0-7409e5d28c80
# ╟─ffcd9a68-c6d7-4b0c-a237-acfa7ec526df
# ╟─e64c2f8c-d83d-41c8-b125-ae911d01b341
# ╟─c6a27711-c67d-41a0-9b87-8d953c91ef0a
# ╟─8e7de4cd-701e-4150-b43e-2760b92f54e5
# ╠═57370204-e7f0-4bf2-a73c-f1c40b73e20b
# ╟─4e3d5d79-d252-47bd-8c14-c82f214741c1
# ╟─79e38641-4892-4f8b-9247-c06a062a3c4f
# ╠═f18fe47c-d5b0-4cbe-bfa9-35a3a2573a48
# ╟─3f54f798-c46e-48d5-8640-460d4d542e33
# ╟─815abcfa-d289-4c99-9ddf-000a1683e591
# ╟─b868885f-91bd-4aa7-b2fa-e8c5bcad7d8c
# ╟─06f0a804-250c-4349-a71e-fc2a3bea6668
# ╟─683d3475-6a34-466d-8442-a1fea40bd96d
# ╟─53823bdc-72c8-4f1e-8dcd-ff24980a54f1
# ╟─9080f415-be7b-4407-b075-2fc9b038cdc5
# ╟─04c0830f-0eaf-4783-8482-799436912d6b
# ╟─a26fec71-b00a-4314-a3e7-18ceadb0d26a
# ╟─96c7edd1-f186-40c3-acd3-76a875dcbc2b
# ╟─fd2ab226-c7ce-4ba9-a6a5-c4e77d3fec82
# ╟─4e96d677-7711-41fa-a9c7-5505ac0fbca8
# ╟─15327498-c1f2-45da-bca6-a6f1dac38737
# ╟─a783043c-edda-4740-81ee-efedd07a4ce2
# ╟─fba42007-d782-4548-80c2-837288231b4c
# ╟─612f45db-f803-4f96-a837-d1edd865483d
# ╟─e1c6daac-9b44-48f8-84eb-46a84a788da4
# ╟─f7316707-8cff-479e-b709-cba78c500f76
# ╟─af7f8c50-b16d-4abd-85e5-47b7953c3a1c
# ╟─5412a106-25e1-4b56-bb81-753199c800f7
# ╟─d06ea18b-64ea-4312-ae93-84eafc27f705
# ╠═d7436990-d916-4a3c-a018-8a9ee7c79ab5
# ╠═b435809f-9cdf-4694-8194-585f02279c13
