% [Main file] FEA analysis beam bending

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

material = input('What is the material of the beam?');

% Apply boundary conditions 
% Fixtures
% Loads

force = input('How much force do you want to apply to the system?');
location = input('At which node?');
fixture = input('Which nodes do you want to fix?');

% --------------------------------

% PREPROCESSING: TRANSLATING THE USER INPUT INTO FEA DATA

% Determine degrees of freedom based on number of nodes
nn = size(node, 1);
dof = 2*nn;

% Determine number of elements based on connectivity matrix
ne = length(conn);

% Define material properties 
% E = "Young's Modulus" (in gigapascals)
    % determines the stiffness of the structure in response to applied loads
% A = "Cross sectional area of each element". In this case, the cross sectional area is assumed to be 2 

switch material
    case 'aluminum'
    E = 69;
    A = 2;
    case 'copper'
    E = 128;
    A = 2;
    case 'steel'
    E = 200;
    A = 2;
end

% Determine how much force is applied
f = zeros(dof,1);
f(location) = force;

% Determine which nodes are free
free = 1:dof;
free(:,fixture) = [];


% --------------------------------

% PROCESSING

% Create global stiffness matrix
K = zeros(dof);
% Create displacement vector
d = zeros(dof,1);
% Calculate local stiffness matrices at each element and input them into
% global stiffness matrix 
for ii=1:ne
% INITIAL SETUP
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
node_new = [node(:,1)+200*u, node(:,2)+200*v];

% --------------------------------

% POST PROCESSING 

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

% Plot the deformed shape with color
figure
switch material
    case 'Aluminum'
        bound = boundary(node_newx,node_newy);
        C = [0.4 0.4 0.4];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
    case 'Copper'
        bound = boundary(node_newx,node_newy);
        C = [0.8 0.5 0.2];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
    case 'Steel'
        bound = boundary(node_newx,node_newy);
        C = [0.27 0.30 0.35];
        graph = fill(node_newx(bound),node_newy(bound),C);
        axis equal
end

% Plot nodal stress diagram
figure
patch(nodex,nodey,stress_node)
colorbar
axis equal
    
