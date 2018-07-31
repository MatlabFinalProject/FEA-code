% Justin Zhang
% 7/31/2018 
% Summer 2018 CEE101S: Homework #5

% Problem 1

% Example using "comet"
% Initialize variables
x = 1:0.001:10;
y1 = cos(x);
y2 = sin(x);
% Use "comet" plot
figure
comet(x,y1);
hold on
comet(x,y2);
% Add title, x label, and y label to graph
title('Cosine and Sine Comet Plot from x = 1 to x = 10')
xlabel('x')
ylabel('y')

% Example using "pie"
% Initialize variables
x = [1 3 5 3 4 5 6];
figure
% Explode the "swimming" and "baseball" section
explode = [0 0 3 0 0 1 0];
% Create the pie graph
p = pie(x,explode);
% Create title for graph
t = title('Favorite Sports of People in my Class');
% Create legend for graph
l = legend('Basketball','Soccer','Baseball','Football','Volleyball','Swimming','Tennis');
% Change the line width of pie chart
set(p,'LineWidth',3)
% Change the fontsize of the tile
set(t,'FontSize',20)
% Change the font size of the legend
set(l,'FontSize',15)

% Example using "bar"
% Initialize variables
y = [10 30 24; 19 50 30; 45 24 23; 30 45 19];
% Create the bar graph
figure
b = bar(y,0.7); % the third input 0.7 changes the width of the bar
% Add title to the graph
t = title('Number of Students in Class 1-4');
% Add legend to graph
l = legend('high school students','undergraduate','graduate');
% Modify title font
set(t,'FontSize',20)
% Modify bar line thickness
set(b,'LineWidth',1.2)
% Modify legend font
set(l,'FontSize',11)
