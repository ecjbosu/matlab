% Unit test script for Options class
% asian(asian, Exdef, Type, S, SA, X, T, T2, V, R, Q)
import instruments.*;

% dates
mdate = datenum('2012-04-15');
cdate = datenum('2012-06-30');
t2date = datenum('2012-06-01');

%contract and scenario
posmult = 1000;
optnum = 40;

%instrument
ExDef = repmat('European',optnum,1);
Type = 'c'; %[repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
S = 40;
V = .25;
X = 40;
R = .005;

%con payout
payout = 1.00;

Exp = repmat((cdate-mdate + 1)/365.25,optnum,1);

P =  [30:S/(optnum-1)/2:S*1.25]';

vanilla = instruments.option(instruments.option, ExDef, Type, P, Exp, R, R, X, V);

vanilla = vanilla.calc(vanilla,'all');
fh=vanilla.plot('S');
matlab.graphics.mtit(fh, 'Standard Vanilla','yoff',0)

%Standard CON Digital
digitalcon = digital();
digitalcon.Typedef = 'con';


%obj, Exdef, Type, S, T, R, Q, X, V, G)
digitalcon=digital(digitalcon, ExDef, Type, P, Exp, R, R, X, V);

digitalcon = digitalcon.calc(digitalcon,'all');

fh = digitalcon.plot('S');
matlab.graphics.mtit(fh, 'Standard Digital CON','yoff',0)

% Standard APO
% outside averaging period
SA = 0;
T2 = (cdate - t2date + 1)/365.25;

%Value option and calculate Greeks
%(obj, Exdef, Type, S, SA, X, T, T2, V, R, Q)
standasianout = asian(asian, ExDef, Type, P, SA, X, Exp, T2, V, R, R);

standasianout = standasianout.calc(standasianout,'all');
fh=standasianout.plot('S');
% outside averaging period standard apo = vanilla
matlab.graphics.mtit(fh, 'Standard Asian Outside Averaging Period','yoff',0)

% Standard APO
% inside averaging period
SAin = 40;
mdatein = datenum('2012-06-15');

T2in = ( mdatein - t2date + 1)/365.25;
Expin = (cdate - mdatein - 1)/ 365.25;
%Value option and calculate Greeks
%(obj, Exdef, Type, S, SA, X, T, T2, V, R, Q)
standasianin = asian(asian, ExDef, Type, P, SAin, X, Expin, T2in, V, R, R);

standasianin = standasianin.calc(standasianin,'all');
fh=standasianin.plot('S');
matlab.graphics.mtit(fh, 'Standard Asian Inside Averaging Period','yoff',0)

%Digital Asian CON 
% outside averaging period
asiandigitalout = asian(asian, ExDef, Type, P, 0, X, Exp, T2, V, R, R);
asiandigitalout.Typedef = 'con';

asiandigitalout = asiandigitalout.calc(asiandigitalout,'all');
asiandigitalout = asiandigitalout.calc(asiandigitalout,'INTRINSIC');

fh=asiandigitalout.plot('S');
matlab.graphics.mtit(fh, 'Digital Asian CON Outside Averaging Period','yoff',0)

%Digital Asian CON 
% inside averaging period
asiandigitalin = asian(asian, ExDef, Type, P, 40, X, Expin, T2in, V, R, R);
asiandigitalin.Typedef = 'con';

asiandigitalin = asiandigitalin.calc(asiandigitalin,'all');

fh=asiandigitalin.plot('S');
matlab.graphics.mtit(fh, 'Digital Asian CON SA=X Inside Averaging Period','yoff',0)

%Digital Asian CON 
% deep in inside averaging period
SAin = 45;
asiandigitalind = asian(asian, ExDef, Type, P, 45, X, Expin, T2in, V, R, R);
asiandigitalind.Typedef = 'con';

asiandigitalind = asiandigitalind.calc(asiandigitalind,'all');

fh=asiandigitalind.plot('S');
matlab.graphics.mtit(fh, 'Digital Asian CON SA>X Inside Averaging Period','yoff',0)

%Digital Asian CON 
% deep out inside averaging period
SAin = 30;
asiandigitalindo = asian(asian, ExDef, Type, P, 30, X, Expin, T2in, V, R, R);
asiandigitalindo.Typedef = 'con';

asiandigitalindo = asiandigitalindo.calc(asiandigitalindo,'all');

fh=asiandigitalindo.plot('S');
matlab.graphics.mtit(fh, 'Digital Asian CON SA<X Inside Averaging Period','yoff',0)

[P asiandigitalout.NPV asiandigitalin.NPV asiandigitalind.NPV asiandigitalindo.NPV]

[P asiandigitalout.PayoutTerm asiandigitalin.PayoutTerm asiandigitalind.PayoutTerm asiandigitalindo.PayoutTerm]

[P asiandigitalout.Delta asiandigitalin.Delta asiandigitalind.Delta asiandigitalindo.Delta]

disp( ['Average : ', num2str(mean(ver1.NPV))]);
MTM = ver1.NPV * MW .* (work.Onhrs + work.OffHrs);
disp ( ['MTM : ' , num2str(sum(MTM))]);

disp( ['Average : ', num2str(mean(c.NPV * payout))]); %6.00
disp( ['Average : ', num2str(mean(c.NPV ))]); %5.25
disp ( ['MTM : ' , num2str(sum(c.NPV .* posmult))]);
optnum = 20;

disp( ['Average : ', num2str(mean(ver2.NPV))]);
disp( ['value Vertical Spread : ', num2str(mean(ver1.NPV - ver2.NPV)/.01 )]);

% [(a.Delta .* a.S) a.Delta (min(abs(a.Delta .* a.S .* payout),payout)) a.S]
% [ver1.Delta ver2.Delta (ver1.Delta-ver2.Delta)/.01 c.Delta]
 [ver1.NPV ver2.NPV (ver1.NPV - ver2.NPV)/.01 c.NPV]
 val = [ver1.NPV  ver2.NPV (ver1.NPV - ver2.NPV)/.01 .* posmult c.NPV .* posmult]
  sum([val(:,3) val(:,4)])
  
  %delta
  [ver1.Delta ver2.Delta (ver1.Delta - ver2.Delta)/.01 c.Delta ]
  [(ver1.Delta - ver2.Delta)/.01 .* posmult1 c.Delta .* posmult1 ]
  