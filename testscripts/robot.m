

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

% str2 = vertcat(str2{:});% str2 = str2(:,1:end-1);
