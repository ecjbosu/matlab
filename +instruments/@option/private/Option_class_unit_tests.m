% Unit test script for Options class
import instruments.*;
optnum = 20;

%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = zeros(optnum,1);

%Value option and calculate Greeks
%Exdef, Type, S, T, R, Q, X, V)
a=option(option,ExDef,Type,P,Exp,R,R,X,vol); %User R for Q since this is an futures option.
a = a.optioncalc(a,'all');

fh = a.plot();
