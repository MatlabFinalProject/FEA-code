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
nl = ceil(l/tol);
nw = ceil(w/tol);
% Create nodes matrix
nodes = [];

% Determine degrees of freedom based on number of nodes
dof = ;

% Create connectivity matrix
conn = ;
% Determine number of elements based on connectivity matrix
ne = ;

% Define material propertieis 
% E = "Young's Modulus"
% A = "Cross sectional area of each element"
E = ;
A = ;

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
% --------------------------------

% POST PROCESSING 

% Calculate stress and strain
for ii=1:ne
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    % Determine x y coordinate of the two nodes
    x1 = nodes(n1,1); y1 = nodes(n2,2);
    x2 = nodes(n1+1,1); y2 = nodes(n2+1,2);
    
    % Calculate the deformation matrix
    B = deformation(x1,y1,x2,y2);
    
    % Calculate stress and strain
    sctr = [2*n1-1 2*n1 2*n2-1 2*n2];
    strain = B*d(sctr);
    stress = strain*E;
end

% Plot original and deformed trusses
figure
plot(node(:,1),node(:,2),'o')
hold on
plot(node_new(:,1),node_new(:,2),'or')

for ii=1:ne
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    x1 = nodes(n1,1); y1 = nodes(n1,2);
    x2 = nodes(n2,1); y2 = nodes(n2,2);
    
    plot([x1 x2],[y1 y2],'b')
    
    x1n = nodes_new(n1,1); y1n = nodes_new(n1,2);
    x2n = nodes_new(n2,1); y2n = nodes_new(n2,2);

    plot([x1n x2n], [y1n y2n], 'r')
end

    
