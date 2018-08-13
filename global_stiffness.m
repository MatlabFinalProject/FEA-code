function K = global_stiffness(conn, N, ne, dof, check)
%GLOBAL_STIFFNESS creates the global stiffness matrix for the inputted
%connectivity matrix and node matrix
K = zeros(dof, dof);

for ii=1:ne
    L = sqrt((N(conn(ii,1),1)-N(conn(ii,2),1))^2 + (N(conn(ii,1),2)-N(conn(ii,2),2))^2);
    P1 = conn(ii, 1); % near end
    P2 = conn(ii, 2); % check coordinates of this (far end)
    lx = (N(P2, 1)-N(P1, 1))/L; % so you divide by ne twice ?
    ly = (N(P2, 2)-N(P1, 2))/L; 
    k = [lx^2 lx*ly -lx^2 -lx*ly;
         lx*ly ly^2 -lx*ly -ly^2;
         -lx^2 -lx*ly lx^2 lx*ly;
         -lx*ly -ly^2 lx*ly ly^2]/L;
     sctr = check(ii,:);
    K(sctr, sctr) = K(sctr, sctr) + k;
end



