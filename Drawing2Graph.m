% DRAWING2GRAPH takes a drawing and constructs a parameterized function,
% which plotted between -pi and pi yields an approximation of the drawing.
% The result is more specifically the coefficients of a Fourier expansion
% with can be evaluated using FSERIESVAL.
%
%[aX, bX, aY, bY] = Drawing2Graph(pic,n) takes a picture pic and a number
%of terms as input and returns coefficients for the sinus and cosinus for
%the parameterized functions for x(t) and y(t).
%
%EXAMPLE USAGE:
%[aX, bX, aY, bY] = Drawing2Graph('DarthVader',300); %find the coefficients
%time = -pi:0.001:pi;
%x = Fseriesval(aX,bX,time);
%y = Fseriesval(aY,bY,time);
%plot(x,y)
%
%LICENSE:
%This code is distributed in the hope that it will be useful, but
%WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
%Public License v.3 or newer for more details. 
%You should have received a copy of the GNU General Public License along
%with planarforest. If not, see <http://www.gnu.org/licenses/>.

%You are welcome to use or change the code for your own purpose, but in
%case of redistributing it have to be distributed under the GNU General
%Public License v.3 or newer.

%AUTHOR LIST:
%
%DRAWING TO GRAPH
%Main author: Nicky Cordua Mattsson
%Date: 2016-01-06
%Version: 1
%Contact: nicky_mattsson@yahoo.dk
%
%FSERIES and FSERIESVAL:
%Main author: Matt Tearle
%Date: 2011-04-11
%Version: 1
%License: BSD License
%
%TSPSEARCH:
%Main author: Jonas Lundgren
%Adaption author: Nicky Cordua Mattsson
%Date: 2015-01-06
%Version: 3
%License: GNU General Public License v.3 or newer
%
function [aX, bX, aY, bY] = Drawing2Graph(pic,n)
%Read image
display('Reading image')
I = imread(pic);
if length(size(I)) == 3
    I = rgb2gray(I);
end

sizeI = size(I);
if sizeI(1)>sizeI(2)
    I = imresize(I, [400 NaN]);
else
    I = imresize(I, [NaN 400]);
end
%Find the edge
display('Finding the edges to draw')
[~, threshold] = edge(I, 'sobel');
fudgeFactor = .85;
BW = edge(I,'sobel', threshold * fudgeFactor);

%Find the x and y values
display('Finding x values')
[y, x] = find(BW);
y = -y+max(y)/2;
x = x-max(x)/2;

%Sort the data
display('Sorting data, this may take some time (it propably will)')
[tour,~] = tspsearch([x,y],1,1e2);
X = x(tour);
Y = y(tour);
display('Done sorting, time to wake up.')

%Do the Fourier analysis
display('Doing the Fourier analysis')
time = (0:length(X)-1)'*2*pi/length(X);
[aX,bX] = Fseries(time,X,n);
[aY,bY] = Fseries(time,Y,n);

%Evaluate the model
display('Evaluating the model')
time = 0:0.001:2*pi;
drawX = Fseriesval(aX,bX,time);
drawY = Fseriesval(aY,bY,time);
plot(drawX,drawY)


