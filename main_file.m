% [Main file] FEA analysis beam bending

% USER INPUTS

% Input dimensions of beam 
l = input('What is the length of your beam? (in feet)');
w = input('What is the width of your beam? (in feet)');
if isnumeric(l) == 0 || isnumeric(w) == 0
    error('Input must be a numerical value')
end 

% Specify tolerance
tol = input('About how long do you want each basic element to be?');

% Specify material properties
% "Aluminum"
% "Copper"
% "Steel"
material = input('What is the material of the beam?');

% Apply boundary conditions 
% Fixtures
fx = input('Specifiy the range of x dimension over which the material will be fixed');
fy = input('Specifiy the range of y dimension over which the material will be fixed');
% Loads
ff = input('Specifiy the range of x y dimensions over which the force will be applied');
fn = input('Specify the force in newtons');


% --------------------------------

% PREPROCESSING: TRANSLATING THE USER INPUT INTO FEA DATA

% Determine how many nodes we need (nn) base on tolerance
nl = ceil(l/tol); % on x axis
nw = ceil(w/tol); % on y axis

% Create nodes matrix
nodes = zeros((nl+1)*(nw+1), 2);
numCol = 1;
for ii = 1:nw+1 
    for jj = 1:tol:(l+1)
        nodes(numCol, 1) = jj-1; % first column
        numCol = numCol + 1;
    end
    nodes(numCol-(nl+1):numCol-1, 2) = tol*(ii-1); % second column
end

% Determine degrees of freedom based on number of nodes
nn = size(nodes, 1);
dof = ;

% Create connectivity matrix
conn = ;

% Determine number of elements based on connectivity matrix
ne = length(conn);

% Define material properties 
% E = "Young's Modulus" (in gigapascals)
    % determines the stiffness of the structure in response to applied loads
% A = "Cross sectional area of each element"
if material == 'aluminum'
    E = 69;
    A = ;
elseif material == 'copper'
    E = 128;
    A = ;
elseif material == 'steel'
    E = 200;
    A = ;
end



% Define boundary conditions
% According to the fixtures, which nodes are constrained? which nodes have
% forces acting on them?
free = ;
fixed = ;
load = ;

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
    x1 = nodes(n1,1); y1 = nodes(n2,2);
    x2 = nodes(n1+1,1); y2 = nodes(n2+1,2);
    
% Compute local stiffness matrix
    kii = loc_stiff(E,A,x1,y1,x2,y2);
    
% Scatter local stiffness matrix into global matrix
    % Determine where in the global stiffness matrix the local matrix goes
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2];
    % Scatter local stiffness matrix into global stiffness matrix
    K(sctr,sctr)= K(sctr,sctr)+kii;
end

% Solve for displacement
d(free) = K(free)\load(free);

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
    x1 = nodes(n1,1); y1 = nodes(n2,2);
    x2 = nodes(n1+1,1); y2 = nodes(n2+1,2);
    
    % Calculate the deformation matrix
    B = deformation(x1,y1,x2,y2);
    
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
plot(node(:,1),node(:,2),'o')
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
    
