function vargout = GESDoutlier(x,r, alpha)
  % The Generalized Extreme Studentized Deviate(GESD), Rosner (1983), procedure test for
  % the presence of up to r outliers in the data set x. This test applies
  % to data sets that are approximately normal.  
  %
  %'x' is the data input on which the test is to be performed. The current
  %version supports only vector inputs
  %
  %'r' is the number of outliers to be checked
  %
  %'alpha' is the significance level of the test
  %
  %'vargout(1)' contains the original data with the detected outliers removed
  %
  %'vargout(2)' contains the outliers that were found in the data
  %
  
  % Error checking
  if nargin == 0
       error('matpacks:GESDoutlier:NotEnoughInputs','Not enough input arguments.'); 
   end
   if nargin > 3
       error('matpacks:GESDoutlier:TooManyInputs', 'Too many input arguments.'); 
   end
   
   % initialize values
   [n c] = size(x);
   R = NaN(1,r);
   no_max = x;
   
   % create a loop for sequentially detecting the outliers, storing them
   % and producing a vector containing the original data without the
   % outliers
   for i = 1:r
        p = 1 - alpha / (2 * (n - i + 1));
        
        % test value
        R(i) = max(abs(no_max - mean(no_max)) / std(no_max));
        
        % critival value
        lambda(i) = tinv(p, n - i - 1) * (n - i) / sqrt((n - i - 1 + tinv(p, n - i - 1) ^ 2)*(n - i + 1));
        
        % test whether the test statistic is greater than the critical
        % value
        if R(i) > lambda(i)
        
        % if the current value is deemed outlier save it    
        outlier(i) =  no_max(abs(no_max - mean(no_max)) == max(abs(no_max - mean(no_max))) > 0);
        
        % remove the outlier value from the data vector
        x_clean = no_max(no_max~=outlier(i));
        end;
        
        % remove the current value that is being tested to be an outlier
        % from the sample and test the next value for being an outlier
        no_max = no_max(abs(no_max - mean(no_max)) ~= max(abs(no_max - mean(no_max))) > 0);
   end
   
       % output values from the test
       vargout{1} = x_clean;
       vargout{2} = outlier;
   
end