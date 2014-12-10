classdef matrixops
    %MATRIXOPS Abstract utility class for matrix operations
    
    methods (Static)
        out            = uppertriangle(in,sz,k);
        out            = lowertriangle(in,sz,k);
        [Over, Under]  = determinespreads(V);
    end
    
end
   

