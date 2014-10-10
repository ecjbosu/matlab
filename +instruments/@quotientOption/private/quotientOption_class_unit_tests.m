% Unit test script for quotientOptions class
import instruments.*;
optnum = 1;

ExDef = repmat('American',optnum,1);
ExDef = repmat('European',optnum,1);
Type = [repmat('c',optnum,1)];% repmat('cc',5,1); repmat('cc',10,1)];
P = [5:5+optnum-1]';
P1 = [5:5+optnum-1]';
X = repmat(0.5,optnum,1);
Exp = repmat(.5,optnum,1);
vol = [repmat(.2,optnum,1)];% repmat(.2,5,1); repmat(.2,10,1)];
R = repmat(.03,optnum,1);
Q = repmat(0,optnum,1);
Q1 = repmat(0,optnum,1);
v1 = [repmat(.2,optnum,1)];
rho = [repmat(.95,optnum,1)]';


%Value option and calculate Greeks
a=quotientOption(quotientOption,ExDef,Type,P,P1, X,Exp,vol,v1,rho, R,R,R);
a = a.optioncalc(a,'all');
fh=  a.plot();
   
    