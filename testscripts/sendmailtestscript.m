% sendmail test


disp('send the email');
    a = security.security();
    a.filename = fullfile(getpref('Gist','XmlRead'),'DailyRiskReportEmailList.xml');
    %a.filename = fullfile(strrep(securitypath,';',''),'TXC_OTC_TRADE_SEQ.xml');
    a = a.setTree();
    d = {a.listitems.EMAIL};
    to = d{1};

    %add to email xmail for signature and contact blurb
    cblurb = sprintf('<div><p>Please contact Joe W. Byers if you have any questions.\n</p></div>');
    sign = sprintf('%s %s\n %s\n %s\n %s\n %s\n %s\n %s\n%s', '<div><p>', ...
            'Joe W. Byers<br>', 'Senior Risk Manager<br>', ...
            'FinancialSEAL<br>', ...
            '9 Oak Hill Dr.<br>', 'Monroe Township, NJ 08831<br>', ...
            'Office: <br>', ....
            'Cell:   918 269 1591', '</p></div>');

    
    subject = ['Daily VaR and Risk Exposures for '];
    body = 'TEST';
  
    
    result = matlab.iofun.sendolmail(to, subject, body);

    if result ~= 1
        disp(result.Message);
    end
