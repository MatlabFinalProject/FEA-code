function fixture_interactive_t(node,conn)
% FORCE_INTERACTIVE_T displays an interactive image for users to specify
% the nodes of the 2D Truss Structure they want to fix while performing the
% Finite Element Analysis. Used with main_file_t.
% node = the nodal coordinates of the truss
% conn = the connectivity matrix of truss

% Define necessary variables
nodex = node(:,1); % x component of nodes
nodey = node(:,2); % y component of nodes
ne = length(conn); % number of elements
nn = size(node, 1); % number of nodes
dof = 2*nn; % degree of freedom

% Initialize variable to return
fixture = [];

% Show the interactive figure 
figure
plot(nodex,nodey,'o')
hold on

for ii=1:ne
    n1 = conn(ii,1);
    n2 = conn(ii,2);
    
    x1 = node(n1,1); y1 = node(n1,2);
    x2 = node(n2,1); y2 = node(n2,2);
    
    plot([x1 x2],[y1 y2],'b--')
    axis equal
    t = title('Close the figure when done with fixing');
    set(t,'FontSize',20)
end

% Create pushbuttons for all seven nodes using uicontrol() and assign
% callback functions to each button.
fix7 = uicontrol('style','pushbutton');
set(fix7,'position', [100 300, 70, 20]);
set(fix7,'string','Fix this node!');
set(fix7,'callback',{@set_fix7})

fix6 = uicontrol('style','pushbutton');
set(fix6,'position', [250 300, 70, 20]);
set(fix6,'string','Fix this node!');
set(fix6,'callback',{@set_fix6})

fix5 = uicontrol('style','pushbutton');
set(fix5,'position', [400 300, 70, 20]);
set(fix5,'string','Fix this node!');
set(fix5,'callback',{@set_fix5})

fix4 = uicontrol('style','pushbutton');
set(fix4,'position', [480 115, 70, 20]);
set(fix4,'string','Fix this node!');
set(fix4,'callback',{@set_fix4})

fix3 = uicontrol('style','pushbutton');
set(fix3,'position', [330 115, 70, 20]);
set(fix3,'string','Fix this node!');
set(fix3,'callback',{@set_fix3})

fix2 = uicontrol('style','pushbutton');
set(fix2,'position', [180 115, 70, 20]);
set(fix2,'string','Fix this node!');
set(fix2,'callback',{@set_fix2})

fix1 = uicontrol('style','pushbutton');
set(fix1,'position', [30 115, 70, 20]);
set(fix1,'string','Fix this node!');
set(fix1,'callback',{@set_fix1})

% Set up callback functions: if a button is clicked, the node is fixed.
function set_fix1(fix1, ~) 
if get(fix1,'value')
    set(fix1,'string','Fixed!')
    fixture = [fixture, 1, 2];
else 
    set(fix1,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 1));
    fixture = fixture(find(fixture ~= 2));
end
assignin('base','fixture',fixture)
end

function set_fix2(fix2, ~) 
if get(fix2,'value')
    set(fix2,'string','Fixed!')
    fixture = [fixture, 3, 4];
else 
    set(fix2,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 3));
    fixture = fixture(find(fixture ~= 4));
end
assignin('base','fixture',fixture)
end

function set_fix3(fix3, ~) 
if get(fix3,'value')
    set(fix3,'string','Fixed!')
    fixture = [fixture, 5, 6];
else 
    set(fix3,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 5));
    fixture = fixture(find(fixture ~= 6));
end
assignin('base','fixture',fixture)
end

function set_fix4(fix4, ~) 
if get(fix4,'value')
    set(fix4,'string','Fixed!')
    fixture = [fixture, 7, 8];
else 
    set(fix4,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 7));
    fixture = fixture(find(fixture ~= 8));
end
assignin('base','fixture',fixture)
end

function set_fix5(fix5, ~) 
if get(fix5,'value')
    set(fix5,'string','Fixed!')
    fixture = [fixture, 9, 10];
else 
    set(fix5,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 9)); 
    fixture = fixture(find(fixture ~= 10)); 
end
assignin('base','fixture',fixture)
end

function set_fix6(fix6, ~) 
if get(fix6,'value')
    set(fix6,'string','Fixed!')
    fixture = [fixture, 11, 12];
else 
    set(fix6,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 11)); 
    fixture = fixture(find(fixture ~= 12));   
end
assignin('base','fixture',fixture)
end

function set_fix7(fix7, ~) 
if get(fix7,'value')
    set(fix7,'string','Fixed!')
    fixture = [fixture, 13 14];
else 
    set(fix7,'string','Fix this node!')
    fixture = fixture(find(fixture ~= 13));
    fixture = fixture(find(fixture ~= 14));
end
assignin('base','fixture',fixture)
end

end