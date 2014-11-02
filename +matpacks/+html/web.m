function out = web( in )
%WEB overload the webbrowser for matlab and displays the input parameter
%text
%   Detailed explanation goes here

 out = web(['text://<html>' in '</html>']);

end

