function string_params = init_string_params()
    num_masses = 3;
    total_mass = 1;
    tension_force = 50;
    string_length = 10;
    damping_coeff = 0.01;
    dx = string_length/(num_masses+1);
    amplitude_Uf = 0.5;
    omega_Uf = 3;

    % system rate functions
    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    % generate struct
    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;
end