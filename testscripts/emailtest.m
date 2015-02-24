
%email test script


import ETL.*;
import connectors.*;
import security.*;
import matlab.*;

%%%%%%%%%%%set up main variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %set COB Date as dummy date
    MarkDate = date();
    

    a = security();
    a.filename = fullfile(gist.environment.matlabDefaultUserpath,'CurveDefsEmailList.xml');
    %a.filename = fullfile(strrep(securitypath,';',''),'TXC_OTC_TRADE_SEQ.xml');
    a = a.setTree();
    d = {a.listitems.EMAIL};
    d = [d, {'financialseal@financialseal.com'}];
    to = strcat(d, ';');
    to = strcat(to{:});

    
    
    subject = ['Risk Systems: Automated Email Test on ' MarkDate];
    body = 'This is a test run for Risk Automated Emails';
  
    
    result = iofun.sendolmail(to, subject ,body);

    
    to = {'financialseal@financialseal.com;financialseal@financialseal.com'};
    
    result = iofun.sendolmail(to, subject ,body);
    
    
exit;
