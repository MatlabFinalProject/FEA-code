% [Main file] FEA analysis beam bending

% USER INPUTS

% Input dimensions of beam 
l = input('What is the length of your beam? (in feet)');
w = input('What is the width of your beam? (in feet)');
if isnumeric(l) == 0 || isnumeric(w) == 0
    error('Input must be a numerical value')
end 

% Specify tolerance
tol = input('How long do you want each element to be?');

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
fn = input('Specify the force in newtons')


% --------------------------------

% PREPROCESSING: TRANSLATING THE USER INPUT INTO FEA DATA

% Determine how many nodes we need (nn) base on tolerance
% Create nodes matrix
% Determine degrees of freedom based no number of nodes

% Create connectivity matrix
% Determine number of elements based on connectivity matrix

% Define material propertieis 
% E = "Young's Modulus"
% A = "Cross sectional area of each element"

% Define boundary conditions
% According to the fixtures, which nodes are constrained? which nodes have
% forces acting on them?

% --------------------------------

% PROCESSING

% Create global stiffness matrix
% Create displacement vector

% Calculate local stiffness matrices at each element
% Process:
% Determine x y coordinate of the two nodes
% Determine sine and cosine value based on the element's inclination 
% Solve local stiffness matrix
% input local stiffness matrix into global stiffness matrix


% Solve for displacement

% --------------------------------

% POST PROCESSING 

% (to be done)

