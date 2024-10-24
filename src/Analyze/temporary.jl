function plot_shear_comparison(s_cap18, s_larsa; title="Shear Comparison", fillalpha=0.5, base_color=:grey)
	min_val = [abs(cap) <= abs(larsa) ? cap : larsa for (cap, larsa) in zip(s_cap18.shear, s_larsa.shear) ]

	cap18_color = :blue
	
	shear_plt = plot(s_cap18, fillcolor=base_color, lc=cap18_color, label="", fillalpha=fillalpha)
	plot!(s_larsa, label="S larsa", fillalpha=1, fillcolor=:red, fillrange=min_val, lc=:red)
	plot!(s_cap18, fillcolor=cap18_color, lc=cap18_color, label="S cap18", fillalpha=1, fillrange=min_val)
	plot!(abs(s_larsa) - abs(s_cap18), 
		fillalpha=1, fillcolor=:orange, lc=:black, label="S diff",
		title = title,
		ylabel="Shear (kips)",
		xlabel="Distance (ft)"
	)
	shear_plt
end

function plot_moment_comparison(m_cap18, m_larsa; title="Moment Comparison", fillalpha=0.5, base_color=:grey)
	min_val = [abs(cap) <= abs(larsa) ? cap : larsa for (cap, larsa) in zip(m_cap18.moments, m_larsa.moments) ]

	cap18_color = :blue
	
	moment_plt = plot(m_cap18, fillcolor=base_color, lc=cap18_color, label="", fillalpha=fillalpha)
	plot!(m_larsa, label="M larsa", fillalpha=1, fillcolor=:red, fillrange=min_val, lc=:red)
	plot!(m_cap18, fillcolor=cap18_color, lc=cap18_color, label="M cap18", fillalpha=1, fillrange=min_val)
	plot!(abs(m_larsa) - abs(m_cap18), 
		fillalpha=1, fillcolor=:orange, lc=:black, label="M diff",
		title = title,
		ylabel="Moment (kip-ft)",
		xlabel="Distance (ft)"
	)
	moment_plt
end

function plot_comparison(s_cap18, s_larsa, m_cap18, m_larsa; 
    legend_pos=legend_pos,
    size = (x_size, y_size), 
    shear_title="Shear Comparison", 
    moment_title="Moment Comparison",
    shear_alpha=0.5,
    moment_alpha=0.5,
    base_color=:grey,
    )
        
    shear_plt = plot_shear_comparison(s_cap18, s_larsa, title=shear_title, fillalpha=shear_alpha, base_color=base_color)
        
    moment_plt = plot_moment_comparison(m_cap18, m_larsa, title=moment_title, fillalpha=moment_alpha, base_color=base_color)
            
    plot(
        shear_plt,
        moment_plt,
        layout = (2, 1),
        legend = legend_pos,
        size = size,
        plot_size=size
    )

end

const legend_pos=:outertopright
const x_size = 721
const y_size = 600

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

function plot_difference(
	s_cap18, s_larsa, m_cap18, m_larsa;
	shear_title="Shear Difference",
	moment_title="Moment Difference",
)
	shear_plt = plot(s_cap18 - s_larsa, title = shear_title, ylabel="Shear (kips)", xlabel="Distance (ft)")
	moment_plt = plot(m_cap18 - m_larsa, title = moment_title, ylabel="Moment (kip-ft)",  xlabel="Distance (ft)")

	plot(
			shear_plt,
			moment_plt,
			layout = (2, 1),
			legend = legend_pos,
			size = (x_size, y_size)
	)
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
