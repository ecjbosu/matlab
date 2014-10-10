% Unit test script for Options class
import instruments.*;
optnum = 20;

ExDef = repmat('American',optnum,1);
ExDef = repmat('European',optnum,1);
Type = [repmat('c',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
P = repmat(15,optnum,1);
X = repmat(optnum/2 + 5,optnum,1);
Exp = [95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5 , 1]' ./ 365;
vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
R = repmat(.03,optnum,1);
Q = repmat(0,optnum,1);

%Value option and calculate Greeks
a=option(option,ExDef,Type,P,X,Exp,vol,R,R);
a = a.optioncalc(a,'all');

fh = a.plot('T');
% 
% fd = figure;
% plot(a.Delta);
% title('Delta');
%     % Create xlabel
%     xlabel('Price');
% fg = figure;
% plot(a.Gamma);
% title('Gamma');
%     % Create xlabel
%     xlabel('Price');
% fv = figure;
% plot(a.Vega);
% title('Vega');
%     % Create xlabel
%     xlabel('Price');
% ft = figure;
% plot(a.Theta);
% title('Theta');
%     % Create xlabel
%     xlabel('Price');
% fr = figure;
% plot(a.Rho);
% title('Rho');
%     % Create xlabel
%     xlabel('Price');
% fn = figure;
% plot(a.NPV);
% title('NPV');
%     % Create xlabel
%     xlabel('Price');
