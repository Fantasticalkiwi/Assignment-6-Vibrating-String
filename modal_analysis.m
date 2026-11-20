%plots the modal analysis graphs
function modal_analysis()

string_params = init_string_params;
[M_mat,K_mat] = construct_2nd_order_matrices(string_params)
%Use MATLAB to solve the generalized eigenvalue problem
[U_mode,eigvals] = eig(K_mat,M_mat);
omega_n = sqrt(-diag(eigvals));


for i = 1:3
    Umode = U_mode(:,i);
    string_params.omega_Uf = (omega_n(i));
    string_simulation(1, 0)

end
end







