% Unit test script for Options class
import instruments.*;
optnum = 100;

%prepare option parameters
ExDef = repmat(cellstr('American'),optnum,optnum);
ExDef = repmat(cellstr('European'),optnum,optnum);
Type = [repmat(cellstr('c'),optnum,optnum)]; %repmat('c',5,1); repmat('c',10,1)];
P = [5:5+optnum-1]';
P = repmat(P,1,optnum);
X = repmat(optnum/2 + 5,optnum,optnum);
Exp = repmat(.5,optnum,optnum);
vol = [repmat(.2,optnum,optnum)]; % repmat(.2,5,1); repmat(.2,10,1)];
R = repmat(.03,optnum,optnum);
Q = repmat(0,optnum,optnum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Value option and calculate Greeks
c=option(option,ExDef,Type,P,Exp,R,R,X,vol); %User R for Q since this is an futures option.

c = c.optioncalc(c,'all');

fh = figure();

fh = c.plot([],'Vega');

