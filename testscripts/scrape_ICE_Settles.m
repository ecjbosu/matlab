function out = scrape_ICE_Settles(markdate)

if nargin < 1 || isempty(markdate);     markdate = floor(now());        end


%set imports
import java.io.IOException;
import java.net.URL;
import java.util.List;

import com.gargoylesoftware.htmlunit.*;
import com.gargoylesoftware.htmlunit.html.*;
import com.steadystate.css.parser.*;

% import com.gargoylesoftware.htmlunit.Page;
% import com.gargoylesoftware.htmlunit.RefreshHandler;
% import com.gargoylesoftware.htmlunit.WebClient;
% import com.gargoylesoftware.htmlunit.html.HtmlAnchor;
% import com.gargoylesoftware.htmlunit.html.HtmlForm;
% import com.gargoylesoftware.htmlunit.html.HtmlPage;
% import com.gargoylesoftware.htmlunit.html.HtmlTable;
% import com.gargoylesoftware.htmlunit.html.HtmlTableRow;
% 
% import com.gargoylesoftware.htmlunit.html.HtmlTextInput;
% import com.gargoylesoftware.htmlunit.html.HTMLParser;
% import org.cyberneko.html.HTMLTagBalancingListener;

%ensure datenum
if ischar(markdate) || iscell(markdate)
    markdate = datenum(markdate);
end

%check if already executed, read the run file
tfile = fullfile(links.dbmart('IceDB', 'System', 'rundatepath').ObservationDefault, ...
    links.dbmart('IceDB', 'System', 'rundatexmlfile').ObservationDefault);

txml = xml.xml(tfile);


% if datenum(txml.tree.Indices.Date) == markdate
% 
%     %done
%     out = MException('gist:webtols_scrape_ICE_Settles:dataFound', ...
%         'Current date %s data is already updated', datestr(markdate, 'mm/dd/yyyy'));
%     gist.tools.stackTrace(out);
%     out = 1;
%     return;
% 
% end


%the internet explorer options must have clear cache, cookies, etc on exit
%for this to work.  Or, figure out how to clear on start up.

%set our nice column labels for dataset result
Ptitles = {'Hub' 'Trade_Date' 'Begin_Date' 'End_Date' 'High' 'Low' ...
    'Avg' 'Chg' 'Volume' 'Num_Deals' 'Num_Cparties'};
% lastHub = 'White';

%we need a url
url = 'https://www.theice.com/marketdata/reports/ReportCenter.shtml?reportId=76';

jpage =  com.gargoylesoftware.htmlunit.WebClient(BrowserVersion.FIREFOX_3_6);
page = jpage.getPage(url);
%d = page.executeJavaScript('doForm2Submit');
%d = page.getFormByName('gasIndexForm');
%
d = page.getElementById('report');
d = d.getElementsByTagName('table');
pause(3);

e = d.item(d.getLength-1);

% e = d.getNextElementSibling;
% 
% while ~e.getClass.toString.contains(java.lang.String('Table'))
%     e = e.getNextElementSibling;
% end

out = cell(e.getRowCount-1, size(Ptitles,2));

for i=1:e.getRowCount-1
    r = e.getRow(i);
    j = 0;
    
    it = r.getCellIterator;
    while it.hasNext
        
        %c = r.getCell(j);
        c = it.nextCell;
        
        j = j+1;
        t1 = char(c.getTextContent.toString.trim);
        out{i,j} = t1;
        
    end
end
 
% robot = java.awt.Robot;

%jbrowser = com.mathworks.mde.webbrowser.WebBrowser.createBrowser;
%jbrowser.setCurrentLocation(url);
% jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% jDesktop.removeClient(jbrowser);
% robot = [];
% clearvars robot; % jbrowser jDesktop;

% web(url, '-browser');
% 
% pause (10);
% robot.keyPress (java.awt.event.KeyEvent.VK_CONTROL);
% robot.keyPress (java.awt.event.KeyEvent.VK_A);
% pause(3);
% robot.keyRelease (java.awt.event.KeyEvent.VK_A);
% robot.keyPress (java.awt.event.KeyEvent.VK_C);
% pause(3);
% robot.keyRelease (java.awt.event.KeyEvent.VK_C);
% robot.keyRelease (java.awt.event.KeyEvent.VK_CONTROL);
% pause(3);
% str = clipboard('paste');
% pause(3);
% 
% robot.keyPress (java.awt.event.KeyEvent.VK_ALT);
% robot.keyPress (java.awt.event.KeyEvent.VK_F);
% pause(3);
% robot.keyRelease (java.awt.event.KeyEvent.VK_A);
% robot.keyPress (java.awt.event.KeyEvent.VK_C);
% pause(3);
% 
% % jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
% % jDesktop.removeClient(jbrowser);
% clearvars robot jbrowser jDesktop;
% 
% str1 = regexp(str, '\n', 'split')';
% idx = regexp(str1, 'Hub ', 'match');
% idx = cellfun(@isempty ,idx);
% 
% [~, y] = ismember(0, idx);
% y = y+1;
% str1 = str1(y:end-1);
% 
% idx = regexp(str1, lastHub, 'match');
% idx = cellfun(@isempty ,idx);
% 
% [~, y] = ismember(0, idx);
% str1 = str1(1:y);
% 
% %check for 3 blanks and replace with 2 blanks arond ''
% str1 = strrep(str1, '   ', '  ''''  ');
% 
% str2 = regexp(str1, '\t', 'split')';
% str2 = vertcat(str2{:});

% str2 = cellfun(@(x) regexp(x, '  ', 'split'), str1, 'UniformOutput', false);

% idx  = cellfun(@(x) size(x, 2), str2, 'UniformOutput', false);
% idx  = min([idx{:}]);

% str2 = cellfun(@(x) x(1:idx), str2, 'UniformOutput', false);

% str2 = vertcat(str2{:});
% str2 = str2(:,1:end-1);

try
    
    out = cell2dataset([Ptitles; out]);
%    out = cell2dataset([Ptitles; str2]);
    
catch ME
    
    % overide the Exception since data not available occurs here
%     out = MException('gist:webtols_scrape_ICE_Settles:dataNotFound', ...
%         'Current date %s data is not available at this time', datestr(markdate, 'mm/dd/yyyy'));
    gist.tools.stackTrace(out);
    out = 1;
    
end

link = links.dbmart('IceDB', 'settles', 'NG');

disp('Extract Settled data')

t1 = cellfun(@(x) datestr(x, 'yyyy-mm-dd'), ...
    datasetfun(@datenum, out(:,2:4), 'UniformOutput', false), ...
    'UniformOutput', false);
t1 = cellfun(@cellstr, t1, 'UniformOutput', false);
t1 = [t1{:}];

try

    out(:, 2:4) = cell2dataset([{'a' 'b' 'c' } ; t1]);
    t1 =  datasetfun(@cell, out(:,5:11), 'UniformOutput', false);
    t1 = [t1{:}];
    t1 =  str2double(t1);

    for i=1:size(t1,2)
        out(:, 4+i)= dataset(t1(:,i));
    end
    
    % fix nans
%     idx = ismissing(out);
%     [r,c]=find(idx==1);
%     out(r,c) = [];
    
catch ME

    gist.tools.stackTrace(ME);
    out = MException('gist:webtols_scrape_ICE_Settles:dataNotFound', ...
        'Current date %s data is not available at this time', datestr(markdate, 'mm/dd/yyyy'));
    gist.tools.stackTrace(out);

    return
    
end

%check if current date.
if unique(datenum(out.Trade_Date)) == markdate

    %First Export the file to excel
%     export(out, 'XLSfile', ...
%         fullfile('\\AD-HOUSTON01\Share\NG Trading\dbMarts\Development\Applications\Curves', ...
%             ['ICESettles-' datestr(date(), 'yyyy-mm-dd') '.xlsx']));

    disp('Push fitted Curve Object to database')
    %Now push to databsae
    link.writedb(out, true);
    
    %update the run file
    nxml = txml.tree;
    nxml.Indices.Date = datestr(markdate, links.dbmart('IceDB','System','dtformat').ObservationDefault);
    out = xml_io_tools.xml_write(txml.filename, nxml, txml.rootname);
    
    disp('send the email');
    
    %%%%%%%%%%%%%%%%%%%%
            myaddress = 'joe.byers@martinenergytrading.com';
            mypassword = '2012martin1';


            setpref('Internet','E_mail',myaddress);
            setpref('Internet','SMTP_Server',char( ...
                links.dbmart('defaultDB', 'mailserver', 'smtp').ObservationDefault));
            setpref('Internet','SMTP_Username', char( ...
                links.dbmart('defaultDB', 'mailserver', 'user').ObservationDefault));
            setpref('Internet','SMTP_Password',mypassword);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %add to email xmail for signature and contact blurb
    cblurb = sprintf(['<div><p> ICE Settles have been scraped and ', ...
        'are available in the MET Database</p>', ...
        '<p>Please contact Joe W. Byers if you have any questions.\n</p></div>']);
    
    sign = sprintf('%s\n %s\n %s\n %s\n %s\n %s\n %s\n', '', ...
            '<div><p>Joe W. Byers<br>', 'Senior Risk Manager<br>', ...
            'Martin Energy Trading LLC<br>', ...
            '3 RiverWay, Suite 400<br>', 'Houston, TX  77056<br>', ...
            'Office: 713 350 5305<br>', ....
            'Cell:   918 269 1591</p></div>');

    subject = ['MET Daily ICE Settle Scrape are comleted for  ' datestr(markdate, 'mm/dd/yyyy')];
    body = sprintf('%s\n %s\n ', cblurb, sign);

    matlab.iofun.sendmail(myaddress, subject, body, 'html');

else
    
    disp('ICE has not Settled')
    out = 1;
    
end

end


