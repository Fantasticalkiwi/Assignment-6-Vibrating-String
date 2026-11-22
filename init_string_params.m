% creates a struct describing the parameters of the string system
%INPUTS:
% num_masses: an integer representing the number of masses on the string. 
%             does not include the initial (stationary) or final (driving)
%             mass.
%OUTPUTS: 
% string_params: a struct containing the system parameters describing the string
%    string_params.n: number of masses
%    string_params.M: total mass attached to the string
%    string_params.Uf_func: function describing motion of end point
%    string_params.dUfdt_func: time derivative of Uf
%    string_params.Tf: %tension in string
%    string_params.L: %length of string
%    string_params.c: %damping coefficient
%    string_params.dx: %horizontal spacing between masses
function string_params = init_string_params(num_masses);
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