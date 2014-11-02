function out = sendolmail(to, cc, subject, body, attachments, bodyformat)
%Sends email using MS Outlook. The format of the function is
%Similar to the SENDMAIL command.
%Mathworks: http://www.mathworks.com/support/solutions/en/data/1-RTY6J/index.html?solution=1-RTY6J


% Create object and set parameters.

if nargin < 1 || isempty(to)
    error('matpacks:iofun:sendolmail: %s', 'Email recipients required');
end

if nargin < 2|| isempty(cc);       cc    = [];     end;
if nargin < 3 || isempty(subject);       subject    = 'No Subject';     end;
if nargin < 4 || isempty(body);          body       = [];               end;
if nargin < 5 || isempty(attachments);   attachments= [];               end;
if nargin < 6 || isempty(bodyformat);    bodyformat = 'olFormatPlain';  end;
out = 1;

try 
    
    %instantiate outlook and create mail item
    
    h               = actxserver('outlook.Application');
    mail            = h.CreateItem('olMail');
    
    %set the mail properties of Subject, to, and body
    mail.Subject    = subject;
    mail.To         = to;
    if ~isempty(cc)
        mail.cc = cc;
    end
    
    mail.BodyFormat = bodyformat;
    mail.HTMLBody   = body;
    %mail.body       = bodytext;
    % Add attachments, if specified.
    if ~isempty(attachments)
        
        for i = 1:length(attachments)
            mail.attachments.Add(attachments{i});
        end
        
    end

    % Send message and release object.
    mail.Send;
    h.release;
    out = true;
    
catch ME
    
    out = ME;
    
    %make sure object is released
    h.release;
    
end
