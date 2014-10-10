% Unit test script for Options class
import instruments.*;
optnum = 100;

%prepare option parameters
Type = [repmat(cellstr('swap'),optnum,optnum)]; %repmat('c',5,1); repmat('c',10,1)];
P = [5:5+optnum-1]';
P = repmat(P,1,optnum);
X = repmat(optnum/2 + 5,optnum,optnum);
Exp = repmat(.5,optnum,optnum);
R = repmat(.03,optnum,optnum);
Q = repmat(0,optnum,optnum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Value option and calculate Greeks
a=forward(forward,Type,P,X,Exp,R,R);
a = a.optioncalc(a,'all');

fh = a.plot;
