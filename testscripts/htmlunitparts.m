
import java.io.IOException;
import java.net.URL;
import java.util.List;

import com.gargoylesoftware.htmlunit.BrowserVersion;
import com.gargoylesoftware.htmlunit.Page;
import com.gargoylesoftware.htmlunit.RefreshHandler;
import com.gargoylesoftware.htmlunit.WebClient;
import com.gargoylesoftware.htmlunit.html.HtmlAnchor;
import com.gargoylesoftware.htmlunit.html.HtmlForm;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import com.gargoylesoftware.htmlunit.html.HtmlTable;
import com.gargoylesoftware.htmlunit.html.HtmlTableRow;

import com.gargoylesoftware.htmlunit.*;
import com.gargoylesoftware.htmlunit.html.*;
import com.gargoylesoftware.htmlunit.html.HtmlTextInput;
import com.gargoylesoftware.htmlunit.html.HTMLParser;
import org.cyberneko.html.HTMLTagBalancingListener;

url = 'https://www.theice.com/marketdata/reports/ReportCenter.shtml?reportId=76';
Ptitles = {'Hub' 'Trade_Date' 'Begin_Date' 'End_Date' 'High' 'Low' ...
    'Avg' 'Chg' 'Volume' 'Num_Deals' 'Num_Cparties'};

jpage =  com.gargoylesoftware.htmlunit.WebClient(BrowserVersion.FIREFOX_3_6);
page = jpage.getPage(url);
% page
% page.getTitleText()
% methods(page)
% page.executeJavaScript('doForm2Submit')
% d=page.executeJavaScript('doForm2Submit');
% d
% d=page.executeJavaScriptIfPossible('doForm2Submit');
% d=page.executeJavaScriptFunctionIfPossible('doForm2Submit');
% d=page.executeJavaScriptFunctionIfPossible();
d = page.executeJavaScript('doForm2Submit');
d = page.getFormByName('gasIndexForm');
% d.getChildElementCount
% 
% st=d.getTextContent;

% for i =1:d.getChildElementCount
% 
%     e{i} = d.getChildElements;
% 
% end
% 
e = d.getNextElementSibling;

while ~e.getClass.toString.contains(java.lang.String('Table'))
    e = e.getNextElementSibling;
end

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

