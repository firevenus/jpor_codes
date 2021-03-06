function minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)
    mcnf = Model(solver=GurobiSolver())

    @variable(mcnf, 0<= x[link in links] <= u_dict[link])

    @objective(mcnf, Min, sum{ c_dict[link] * x[link], link in links}  )

    for i in nodes
        @constraint(mcnf, sum{x[(ii,j)], (ii,j) in links; ii==i }
                           - sum{x[(j,ii)], (j,ii) in links; ii==i } == b[i])
    end

    status = solve(mcnf)
    obj = getobjectivevalue(mcnf)
    x_star = getvalue(x)

    return x_star, obj, status
end
