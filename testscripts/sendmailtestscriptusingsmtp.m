


smtp = gist.environment.nargsin('mailserver', 'smtp');

% Modify these two lines to reflect
% your account and password.
my = security.getuserProperties;

setpref('Internet','E_mail', my.get('user'));
setpref('Internet','SMTP_Server',char( ...
    links.dbmart('defaultDB', 'mailserver', 'smtp').ObservationDefault));
setpref('Internet','SMTP_Username', char( ...
    links.dbmart('defaultDB', 'mailserver', 'user').ObservationDefault));
setpref('Internet','SMTP_Password',my.get('password'));

props = java.lang.System.getProperties;
props.setProperty(char( ...
    links.dbmart('defaultDB', 'mailserver', 'auth').Pref), ...
    char(links.dbmart('defaultDB', 'mailserver', 'auth').ObservationDefault));
props.setProperty(char( ...
    links.dbmart('defaultDB', 'mailserver', 'socketFactory').Pref), ...
    char(links.dbmart('defaultDB', 'mailserver', 'socketFactory').ObservationDefault));
props.setProperty(char( ...
    links.dbmart('defaultDB', 'mailserver', 'Port').Pref), ...
    char(links.dbmart('defaultDB', 'mailserver', 'Port').ObservationDefault));


%  sendmail(myaddress, 'mail Test', 'This is a test message.');
% builtin('@sendmail', 'mail Test', 'This is a test message.');

 matlab.iofun.sendmail('joe.byers@financialseal.com', 'mail Test', 'This is a test message.');

