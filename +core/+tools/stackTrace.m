function out = stackTrace( ME )
%STACKTRACE DUMP THE ERROR STACK
%   

    disp('<StackTrace>')
        
        for i = 1:numel(ME.stack)
            disp(['<Level' num2str(i) '>'])

                disp('<FileName>')
                    disp(ME.stack(i).file)
                disp('</FileName>')
            
                disp('<LineNumber>')
                    disp(num2str(ME.stack(i).line))
                disp('</LineNumber>')

            disp(['</Level' num2str(i) '>'])
        end
    
        disp('<ErrorMessage>')
            disp(ME.message)
        disp('</ErrorMessage>')
    
    disp('<StackTrace>')
        
    disp('<ErrorFlag>true</ErrorFlag>')



end

