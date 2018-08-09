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
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    % Determine x y coordinate of the two nodes
    x1 = nodes(n1,1); y1 = nodes(n2,2);
    x2 = nodes(n1+1,1); y2 = nodes(n2+1,2);
    kii = loc_stiff(E,A,L,x1,y1,x2,y2);
    
    % Scatter local stiffness matrix into global matrix
    K = loc2glob(kii,n1,n2);

end
% Solve for displacement
d(free) = K(free)\load(free);
% --------------------------------

% POST PROCESSING 

% (to be done)
