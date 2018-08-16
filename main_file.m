% [Main file] 2D TrussFEA analysis
% This MATLAB program analyzes how a simple 2D truss structure reacts to
% various amount of external forces, using Finite Element Analysis. 
% 
% In the process of FEA, the following assumptions are made:
% - Same young's modulus for tension and compression
% - 
%
% Here are some limitations of the program: 
% - Few material settings available (aluminum, copper, and steel only)
% - Only able to analyze 2D Truss Structures (different elements have different
%   stiffness matrices and deformation matrices
% - 
% ************************************************************************
% Created by Anna Simmons and Justin Zhang. 
% amsimmon@stanford.edu, jzhang09@stanford.edu
% 
% CEE 101S Summer 2018 Final Project                                  
% MATLAB R2018a                                                       
% -----------------------------------------------------------------------------

% ----------------------------------------------------------------------------------
% SETUP & USER INPUT: DEFINING THE TRUSS STRUCTURE/ASKING USERS FOR SPECIFICATIONS  | 
% ----------------------------------------------------------------------------------

close all; clear; clc

% SETUP
% Truss is in ft

% Define nodal coordinate matrix
node=[0.0 0.0; 
      1.0 0.0; 
      2.0 0.0; 
      3.0 0.0; 
      2.5 1.0;
      1.5 1.0; 
      0.5 1.0];
  
nodex = node(:,1); % x component of nodes
nodey = node(:,2); % y component of nodes
  
 % Define connectivity matrix
 conn=[1 2;
       2 3;
       3 4;
       7 6;
       6 5;
       1 7;
       7 2;
       2 6;
       6 3;
       3 5;
       5 4 ]; 

% USER INPUT 

% Specify material properties
material = menu('What is the material of the beam?','Aluminum','Copper','Steel'); % don't need ' ' for this

% Specify cross sectional area
crossCell = inputdlg('What is the cross sectional area of your trusses (ft^2)'); % don't need ' ' for this
cross = num2str(crossCell{1});

% -------------------------------------------------------------------------------
% PREPROCESSING: TRANSLATING THE SETUP DATA AND USER INPUT DATA INTO FEA DATA    | 
% -------------------------------------------------------------------------------

% Determine degrees of freedom based on number of nodes
nn = size(node, 1);
dof = 2*nn;

% Determine number of elements based on connectivity matrix
ne = length(conn);

% Define material properties 
% E = "Young's Modulus" (in gigapascals)
    % determines the stiffness of the structure in response to applied loads
% A = "Cross sectional area of each element". In this case, the cross sectional area is assumed to be 2 

A = cross;
switch material
    case 1 % That is, the user chose aluminum in the dialogue box
    E = 69;
    case 2 % That is, the user chose copper in the dialogue box
    E = 128;
    case 3 % That is, the user chose steel in the dialogye box
    E = 200;
end

% Determine how much force is applied
% Apply boundary conditions 
force_interactive_t(node,conn); % specify force
fprintf('Press any key to continue!\n')
pause
fixture_interactive_t(node,conn); % specify fixture
fprintf('Press any key to continue!\n')
pause

% Determine which nodes are free
free = 1:dof;
free(:,fixture) = [];

% ----------------------------------------------------------------------------------------------
% PROCESSING: COMPUTING THE DISPLACEMENT OF TRUSS UNDER STRESS USING THEDIRECT STIFFNESS METHOD |
% ----------------------------------------------------------------------------------------------

% Create global stiffness matrix
K = zeros(dof);
% Create displacement vector
d = zeros(dof,1);

% Calculate local stiffness matrices at each element and input them into
% global stiffness matrix 
for ii=1:ne
    % Determine the nodes' index
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    % Determine x y coordinate of the two nodes
    x1 = node(n1,1); y1 = node(n1,2);
    x2 = node(n2,1); y2 = node(n2,2);
    
% Compute local stiffness matrix
    kii = loc_stiff_t(E,A,x1,y1,x2,y2);
    
% Scatter local stiffness matrix into global matrix
    % Determine where in the global stiffness matrix the local matrix goes
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2];
    % Scatter local stiffness matrix into global stiffness matrix
    K(sctr,sctr)= K(sctr,sctr)+kii;
end

% Solve for displacement
d(free) = K(free,free)\f(free);

% Re-structure d into normal displacement
u = d(1:2:end);
v = d(2:2:end);

% Create new matrix describing the new position of the nodes after force is
% applied
node_new = [node(:,1)+u, node(:,2)+v];
node_newx = node_new(:,1);
node_newy = node_new(:,2);


% ------------------------------------------------------------------------------
% POSTPROCESSING: PLOTTING & CALCULATING THE STRESS AND STRAIN OF THE STRUCTURE |
% ------------------------------------------------------------------------------

% Calculate stress and strain

% Define vectors that store the stress and strain values
strain = zeros(ne,1);
stress = zeros(ne,1);

% Define vectors that store nodal stress for eah node 
for ii=1:nn
    name = ['stress_node',num2str(ii),'= [];'];
    eval(name)
end

for ii=1:ne
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    % Determine x y coordinate of the two nodes
    x1 = node(n1,1); y1 = node(n1,2);
    x2 = node(n2,1); y2 = node(n2,2);
    
    % Calculate the deformation matrix
    B = deformation_t(x1,y1,x2,y2);
    
    % Calculate stress and strain at elements
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2];
    strain(ii) = B*d(sctr);
    stress(ii) = strain(ii)*E;
    
    % Calculate stress at individual nodes (assuming each node shares the
    % stress equally)
    eval(['stress_node',num2str(n1),'= [', 'stress_node',num2str(n1), ', stress(ii) ];'])
    eval(['stress_node',num2str(n2),'= [', 'stress_node',num2str(n2), ', stress(ii) ];'])
    
end

% Calculate final nodal stress
stress_node = [];
for ii =1:nn
    eval(['k = mean(','stress_node',num2str(ii), ');'])
    stress_node = [stress_node; k];
end

% Display the stress and strain 
fprintf('ELEMENT        STRESS        STRAIN')

% Plot the system 
figure
plot(nodex,nodey,'o')
hold on
plot(node_new(:,1),node_new(:,2),'or')


for ii=1:ne
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    x1 = node(n1,1); y1 = node(n1,2);
    x2 = node(n2,1); y2 = node(n2,2);
    
    plot([x1 x2],[y1 y2],'b--')
    
    x1n = node_new(n1,1); y1n = node_new(n1,2);
    x2n = node_new(n2,1); y2n = node_new(n2,2);

    plot([x1n x2n], [y1n y2n], 'r')
    axis equal
end
title('Original Truss and Truss with Deformation'); xlabel('x nodes (ft)'); ylabel('y nodes (ft)'); legend('original', 'deformed');

% Plot the deformed shape with color
figure
switch material
    case 1 % aluminum
        bound = boundary(node_newx,node_newy,1);
        C = [0.7 0.7 0.7];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
        legend('Aluminum')
    case 2 % copper
        bound = boundary(node_newx,node_newy,1);
        C = [0.8 0.5 0.2];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
        legend('Copper')
    case 3 % steel
        bound = boundary(node_newx,node_newy,1);
        C = [0.27 0.30 0.35];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
        legend('Steel')
end
title('Deformed Truss');  xlabel('x nodes (ft)'); ylabel('y nodes (ft)');

% Plot nodal stress diagram
figure
patch(nodex,nodey,stress_node)
cb = colorbar; title(cb, 'stress');
axis equal
title('Nodal Stress Diagram with Color');  xlabel('x nodes (ft)'); ylabel('y nodes (ft)');