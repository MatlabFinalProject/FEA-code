function K = global_stiffness(conn, N, ne, dof, check)
%GLOBAL_STIFFNESS creates the global stiffness matrix for the inputted
%connectivity matrix and node matrix
K = zeros(dof, dof);

for ii=1:ne
    P1 = conn(ii, 1); % near end
    P2 = conn(ii, 2); % check coordinates of this (far end)
    lx = (N(P2, 1)-N(P1, 1))/ne; % so you divide by ne twice ?
    ly = (N(P2, 2)-N(P1, 2))/ne; 
    k = [lx^2 lx*ly -lx^2 -lx*ly;
         lx*ly ly^2 -lx*ly -ly^2;
         -lx^2 -lx*ly lx^2 lx*ly;
         -lx*ly -ly^2 lx*ly ly^2]/ne;
     sctr = check(ii,:);
    K(sctr, sctr) = K(sctr, sctr) + k;
end

