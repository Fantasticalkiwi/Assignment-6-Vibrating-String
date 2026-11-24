% Function that calculates modal analysis y-positions
%INPUTS:
% string_params: a struct containing the system parameters describing the string
%    string_params.n: number of masses
%    string_params.M: total mass attached to the string
%    string_params.Uf_func: function describing motion of end point
%    string_params.dUfdt_func: time derivative of Uf
%    string_params.Tf: %tension in string
%    string_params.L: %length of string
%    string_params.c: %damping coefficient
%    string_params.dx: %horizontal spacing between masses
% modality: an integer ranging from 1 to string_params.n denoting the mode
%           to calculat
% func: the function used to compute dXdt
% tspan: a two element vector [t_start,t_end] that denotes the integration endpoints
% h_ref: the desired value of the average step size (not the actual value)
% BT_struct: a struct that contains the Butcher tableau
%            BT_struct.A: matrix of a_{ij} values
%            BT_struct.B: vector of b_i values
%            BT_struct.C: vector of c_i values
% p: how error scales with step size (error = k*hˆp)
% error_desired: the desired local truncation error at each step
% growth_limit: the highest factor the step size is allowed to grow by
%OUTPUTS:
% t_list: the vector of times, [t_start;t_1;t_2;...;.t_end] that the 
%         y_positions are approximated at
% V_list: the vector of positions, [y0', y1', y2', ..., (y_end)'] at each time 
%         step for each mass
function [tlist,Vlist] = modal_analysis(string_params,modality,epsilon,func,tspan, ...
                        h_ref,BT_struct,p,error_desired,growth_limit)
    % initialize parameters
    n = string_params.n;
    V_eq = zeros(n*2,1);

    % construct parameter matrices
    [M_mat,K_mat] = construct_2nd_order_matrices(string_params);
    
    % solve the generalized eigenvalue problem
    [U_mode,eigvals] = eig(K_mat,M_mat);
    %resonance frequencies
    omega_n = sqrt(diag(eigvals));
    

    % calculate initial condition
    m = modality;
    V0 = V_eq + epsilon.*[U_mode(:,m); zeros(n,1)];

    tlist = explicit_RK_variable_step_integration(func,tspan,V0, ...
                        h_ref,BT_struct,p,error_desired,growth_limit);
    Vlist = [];
    for i = 1:n
        y_position = V_eq(i) + epsilon*U_mode(i,m)*cos(omega_n(m)*tlist);
        Vlist(end+1,:) = y_position;
    end
    
end







