% Unit test script for Options class
import instruments.*;
optnum = 20;

%Set up the option paramters
    Type = repmat(cellstr('swap'),optnum,1); %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    R = repmat(.03,optnum,1);
    Q = zeros(optnum,1);

%Value option and calculate Greeks
a=forward(forward,Type,P,X,Exp,R,R); %User R for Q since this is a swap.
a = a.optioncalc(a,'all');

fh = a.plot('S');


%%%Espilon PWR West test
save('data1.mat', 't1','-v7.3');
load('data1.mat');
t1.Properties.VarNames
import instruments.*
a=forward()
a=forward(forward,t1.TRADE_TYPE_CD,t1.PRICE,t1.STRIKE,(t1.DELIVERY_PERIOD-t1.PORTFOLIO_DATE)/365,t1.RATE)
a=a.optioncalc(a,'NPV');
[S(1:10) X(1:10)]
nms=t1.Properties.VarNames;
nms
mtm= t1.MTM_CURRENT_VALUE;
mtm
mtm(1:10)
a.NPV(1:10)
[a.NPV(1:10) mtm(1:10)]
nms
tmtm =[(a.NPV .* t1.NOTIONAL) mtm (a.NPV .* t1.NOTIONAL - mtm) ];


tmtm(end-10:end,:)% =[a.NPV(end-10:end).*t1.DELTA(end-10:end) mtm(end-10:end) a.NPV(end-10:end).*t1.DELTA(end-10:end)-mtm(end-10:end)];
 a.T(end-10:end)
 t1(end-10:end,10:end-3)