% Unit test script for Options class
% asian(asian, Exdef, Type, S, SA, X, T, T2, V, R, Q)
import instruments.*;

filepath = 'C:\METmat\mfiles\+instruments\@asian\private';
fname = 'FE APOs.xls';
work = dataset('XLSFile',fullfile(filepath,fname),'sheet','Sheet2');

r = .006; %.0005;
F = 40; %42
payout = 1.85;  %3.35
MW = 100; %200
posmult = payout * MW .* (work.Onhrs + work.OffHrs);
posmult1 = MW .* (work.Onhrs + work.OffHrs);

S = (work.ON .* work.Onhrs + work.Off .* work.OffHrs) ./ ( work.Onhrs + work.OffHrs);
V = work.Vol;
n = size(V, 1);
ED = repmat('european', n, 1);
Exp = (datenum(work.Contract) + repmat(15, n, 1) - datenum(repmat(date(), n, 1))) / 365;
b = instruments.option(instruments.option, ED, repmat('p', n, 1), S, repmat(F, n, 1), ...
    Exp, V, repmat(r, n, 1), repmat(r, n, 1));

b = b.optioncalc(b,'all');


% Standard APO

SA = zeros(n, 1);
T2 = (edate(datenum(work.Contract),0, 'end') - edate(datenum(work.Contract),0, 'beg') + 1) / 365;
Exp = (edate(datenum(work.Contract),0, 'end') - datenum(repmat(date(), n, 1)) ) / 365;

%Value option and calculate Greeks
ver1 = asian(asian, ED, repmat('p', n, 1), S, SA, ...
    repmat(F, n, 1), Exp, T2, V, repmat(r, n, 1), repmat(r, n, 1));
%a.Typedef = 'aon';

ver1 = ver1.optioncalc(ver1,'all');
disp( ['Average : ', num2str(mean(ver1.NPV))]);
MTM = ver1.NPV * MW .* (work.Onhrs + work.OffHrs);
disp ( ['MTM : ' , num2str(sum(MTM))]);

% Digital CON

SA = zeros(n, 1);
T2 = (edate(datenum(work.Contract),0, 'end') - edate(datenum(work.Contract),0, 'beg') + 1) / 365;

%Value option and calculate Greeks
c = asian(asian, ED, repmat('p', n, 1), S, SA, repmat(F, n, 1), ...
    Exp, T2, V, repmat(r, n, 1), repmat(r, n, 1));
c.Typedef = 'con';

c = c.optioncalc(c,'all');
disp( ['Average : ', num2str(mean(c.NPV * payout))]); %6.00
disp( ['Average : ', num2str(mean(c.NPV ))]); %5.25
disp ( ['MTM : ' , num2str(sum(c.NPV .* posmult))]);
optnum = 20;

    ExDef = repmat('American',optnum,1);
    ExDef = repmat('European',optnum,1);
    Type = [repmat('p',optnum,1)]; %repmat('c',5,1); repmat('c',10,1)];
    P = [12:S(1)/optnum:S(1)*1.25]';
    X = repmat(F,optnum,1);
    Exp = repmat(Exp(1),optnum,1);
    vol = [repmat(V(1),optnum,1)]; % repmat(.2,5,1); repmat(.2,10,1)];
    R = repmat(r(1),optnum,1);
    Q = repmat(r(1),optnum,1);
    
    G = repmat(0, optnum, 1);

%Value option and calculate Greeks
a = digital();
a.Typedef = 'con';

a=digital(a, ExDef,Type,P,X,Exp,vol,R,R,G); 
a = a.optioncalc(a,'all');

fh = a.plot('S');

%%%%%Vertical Spread APO
% use ver1 from above and calc ver2 a .01 strike difference and add results
% together
%Value option and calculate Greeks
ver2 = ver1.copy;
ver2.X = repmat(F - .01, n, 1);
%a.Typedef = 'aon';

ver2 = ver2.optioncalc(ver2,'all');
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