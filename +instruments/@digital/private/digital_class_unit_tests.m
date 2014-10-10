% Unit test script for Options class
import instruments.*;
import instruments.option.*;
import instruments.digital.*;

optnum = 20;
fileloc = 'C:\BPMatlab\+instruments\@digital\private\figures';

%Zhang replications
con402c = digital();
con402p = digital();
con402c.Typedef = 'con';
con402p.Typedef = 'con';
con402c = digital(con402c,'European', 'c', 100, 100, 1, .2, .08, .03, 0);
con402p = digital(con402p,'European', 'p', 100, 100, 1, .2, .08, .03, 0);
con402c = con402c.optioncalc(con402c, 'all');
con402p = con402p.optioncalc(con402p, 'all');
gap404c = digital();
gap404c.Typedef = 'gap';
gap404c = digital(gap404c,'European', 'c', 100, 105, .5, .2, .07, .03, 102);
gap404c = gap404c.optioncalc(gap404c, 'all');
% corrected Zhang value: 100*exp(-.03*.5)* .4471 - 102*exp(-.07*.5)*.3919 =
% 5.4454
gap404c = digital(gap404c,'European', 'c', 100, 105, .5, .2, .07, .03, 107);
gap404c = gap404c.optioncalc(gap404c, 'all');
% corrected Zhang value: 100*exp(-.03*.5)* .4471 - 107*exp(-.07*.5)*.3919 =
% 3.5533

aon405c = digital();
aon405c.Typedef = 'aon';
aon405c = digital(aon405c,'European', 'c', 100, 105, .5, .2, .07, .03, 102);
aon405c = aon405c.optioncalc(aon405c, 'all');
% corrected Zhang value: 100*exp(-.03*.5)* .4471 = 44.0444
aon405c = digital(aon405c,'European', 'p', 100, 105, .5, .2, .07, .03, 102);
aon405c = aon405c.optioncalc(aon405c, 'all');
% corrected Zhang value: 100*exp(-.03*.5)* .5529 = 54.4668

%%%%%%%%%HUAG digital Tests

%%%%%%%%%%%%%%%%%%%%%%
% CON PUT Test
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
a = digital();
a.Typedef = 'con';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Con_put','.png']));
saveas(fh,fullfile(fileloc,['Con_put','.fig']));

% COMPARE WITH EUROPEAN
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
b = option();
b.Typedef = 'blackscholes';

b=option(b, ExDef,Type,P,X,Exp,vol,R,R); 
b = b.optioncalc(b,'all');

fh = b.plot('S');
saveas(fh,fullfile(fileloc,['EU_put','.png']));
saveas(fh,fullfile(fileloc,['EU_put','.fig']));

% CON Call Test
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('c',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
a = digital();
a.Typedef = 'con';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Con_call','.png']));
saveas(fh,fullfile(fileloc,['Con_call','.fig']));

% aon CAll Test
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('c',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
a = digital();
a.Typedef = 'aon';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Aon_call','.png']));
saveas(fh,fullfile(fileloc,['Aon_call','.fig']));

% aon PUT Test
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
a = digital();
a.Typedef = 'aon';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Aon_put','.png']));
saveas(fh,fullfile(fileloc,['Aon_put','.fig']));

% gap PUT Test G=X is vanilla option
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = X;

%Value option and calculate Greeks
a = digital();
a.Typedef = 'gap';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Gap_put_G=X','.png']));
saveas(fh,fullfile(fileloc,['Gap_put_G=X','.fig']));


% gap CALL Test G=X is vanilla option
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('c',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = X;

%Value option and calculate Greeks
a = digital();
a.Typedef = 'gap';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Gap_call_G=X','.png']));
saveas(fh,fullfile(fileloc,['Gap_call_G=X','.fig']));

% gap CALL Test G<>X is not vanilla option
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('c',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = P + 1;

%Value option and calculate Greeks
a = digital();
a.Typedef = 'gap';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Gap_call_G=1','.png']));
saveas(fh,fullfile(fileloc,['Gap_call_G=1','.fig']));

% gap PUT Test G<>X is not vanilla option
%Set up the option paramters
    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [5:5+optnum-1]';
    X = repmat(optnum/2 + 5,optnum,1);
    Exp = repmat(.5,optnum,1);
    vol = [repmat(.2,optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(.03,optnum,1);
    Q = repmat(0,optnum,1);
    
    G = P - 1;

%Value option and calculate Greeks
a = digital();
a.Typedef = 'gap';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');
saveas(fh,fullfile(fileloc,['Gap_put_G=1','.png']));
saveas(fh,fullfile(fileloc,['Gap_put_G=1','.fig']));
