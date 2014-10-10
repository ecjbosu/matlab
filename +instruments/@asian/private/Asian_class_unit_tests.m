% Unit test script for Options class
% asian(asian, Exdef, Type, S, SA, X, T, T2, V, R, Q)
import instruments.*;

optnum = 20;
% Huag Asian inputs p, 90, 88, 95, .25, .25, .07, .02, .25 b = r - q so q =
% r - b or .05
ExDef = repmat('American', optnum, 1);
ExDef = repmat('European', optnum, 1);
Type = repmat('p', optnum, 1); 
P = repmat( 90, optnum, 1);
SA = repmat(88 , optnum, 1);
X = repmat(95 , optnum, 1);
Exp = repmat(.25, optnum, 1);
T2 = repmat(.25, optnum, 1);
vol = repmat(.25, optnum, 1);
R = repmat(.07, optnum, 1);
Q = repmat(0.05, optnum, 1);

%Value option and calculate Greeks
a = asian(asian, ExDef, Type, P, SA, X, Exp, T2, vol, R, Q);
a = a.optioncalc(a,'all');

fh = a.plot('S');

% Digital AON
import instruments.*;

optnum = 1;
% Huag Asian inputs p, 90, 88, 95, .25, .25, .07, .02, .25 b = r - q so q =
% r - b or .05
ExDef = repmat('American', optnum, 1);
ExDef = repmat('European', optnum, 1);
Type = repmat('p', optnum, 1); 
P = repmat( 90, optnum, 1);
SA = repmat(88 , optnum, 1);
X = repmat(95 , optnum, 1);
Exp = repmat(.25, optnum, 1);
T2 = repmat(.25, optnum, 1);
vol = repmat(.25, optnum, 1);
R = repmat(.07, optnum, 1);
Q = repmat(0.05, optnum, 1);

%Value option and calculate Greeks
a = asian(asian, ExDef, Type, P, SA, X, Exp, T2, vol, R, Q);
a.Typedef = 'aon';

a = a.optioncalc(a,'all');
