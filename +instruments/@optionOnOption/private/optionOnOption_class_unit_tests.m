% Unit test script for optionOnOptions class
import instruments.*;
optnum = 20;

ExDef = repmat('American',optnum,1);
ExDef = repmat('European',optnum,1);
Type = [repmat('cc',optnum,1)];% repmat('cc',5,1); repmat('cc',10,1)];
P = [5:5+optnum-1]';
X2 = repmat(2.5,optnum,1);
X = repmat(15,optnum,1);
Exp = repmat(.5,optnum,1);
Exp2 = repmat(1,optnum,1);
vol = [repmat(.2,optnum,1)];% repmat(.2,5,1); repmat(.2,10,1)];
R = repmat(.03,optnum,1);
Q = repmat(0,optnum,1);

%Value option and calculate Greeks
a=optionOnOption(optionOnOption,ExDef,Type,P,X,X2,Exp,Exp2,vol,R,R);
a = a.optioncalc(a,'all');
fh=  a.plot();
   

% xaxis = strcat(cellstr(num2str(a.NPV(:), '%4.1f')), '/', ...
%     cellstr(num2str(a.UND.S(:), '%4.f')))
% xaxis = vertcat(cellstr(num2str(a.NPV(:), '%4.1f'))', ...
%     cellstr(num2str(a.UND.S(:), '%4.f'))');
% 
% fd = figure;
% plot(a.Delta);
% set(gca,'XTickLabel',xaxis);
% title('Delta');
%     % Create xlabel
%     xlabel('Price');
% fg = figure;
% plot(a.Gamma);
% set(gca,'XTickLabel',xaxis);
% title('Gamma');
%     % Create xlabel
%     xlabel('Price');
% fv = figure;
% plot(a.Vega);
% set(gca,'XTickLabel',xaxis);
% title('Vega');
%     % Create xlabel
%     xlabel('Price');
% ft = figure;
% plot(a.Theta);
% set(gca,'XTickLabel',xaxis);
% title('Theta');
%     % Create xlabel
%     xlabel('Price');
% fr = figure;
% plot(a.Rho);
% set(gca,'XTickLabel',xaxis);
% title('Rho');
%     % Create xlabel
%     xlabel('Price');
% fn = figure;
% plot(a.NPV);
% set(gca,'XTickLabel',xaxis);
% title('NPV');
%     % Create xlabel
%     xlabel('Price');

    