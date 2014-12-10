classdef gist < dynamicprops & matlab.mixin.Copyable %% & matlab.mixin.Heterogeneous
    
    %GIST   The parent class of all classes
    
    
    properties

        Tag         = ''    %   String field for short name labeling
        Label       = '';   %   String field for long name labeling
        Timestamp   = now;  %   Numeric time of object creation
        
    end
    
    methods(Static)
        out       = strcat(inStr, delim);
        out       = nan(InputSize);
        OutMat    = matrixref(OutMat, InMat, OutIndx, InIndx, DimensionIndx);
        varargout = scalarexpand(varargin);
        out       = isequal(varargin);
    end
    
    methods(Access = protected, Hidden)

%%  copyElement
        
        function out = copyElement(obj)

            %       Copies the all properties including dynamicproperties.
            %       Copies encapsulated copyable objects.

            %   Determine Encapsulated Copyable Objects

            indepProps = independentproperties(obj, false);
            copyableIdx    = false(size(indepProps));

            for i = 1:numel(indepProps)
                copyableIdx(i) = isa(obj(1).(indepProps{i}), 'matlab.mixin.Copyable');
            end

            copyableIdx = find(copyableIdx);

            %   Object Loop

            for i = 1:numel(obj)

                %   Copy object element using inherited Copyable method

                out(i) = copyElement@matlab.mixin.Copyable(obj(i)); %#ok

                %   Copy encapsulated copyable objects

                for j = 1:numel(copyableIdx)
                    propNm          = indepProps{copyableIdx(j)};
                    out(i).(propNm) = obj(i).(propNm).copy; %#ok
                end

                %   Determine Encapsulated Structures
                
                structIdx = false(size(indepProps));

                for j = 1:numel(indepProps)
                    structIdx(j) = isstruct(obj(i).(indepProps{j}));
                end
                
                structIdx = find(structIdx);
                
                %   Copy Structure Fields
                
                for j = 1:numel(structIdx)

                    StructProp = obj(i).(indepProps{structIdx(j)});
                    FieldNames = fieldnames(StructProp);
                    
                   for k = 1:numel(FieldNames)
                        if isa(StructProp.(FieldNames{k}), 'matlab.mixin.Copyable')
                            out(i).(indepProps{structIdx(j)}).(FieldNames{k}) = ...
                                StructProp.(FieldNames{k}).copy; %#ok
                        end
                   end
                   
                end
                
                
                %   Extract Dynamic Properties

                DynamicProperties  = dynamicproperties(obj(i));

                %   Dynamic Property Loop

                for j = 1:numel(DynamicProperties)
                    out(i).addprop(DynamicProperties{j});
                    out(i).(DynamicProperties{j}) = obj(i).(DynamicProperties{j}); %#ok
                end

            end

            %   Reshape

            out = reshape(out, size(obj));
        
        end
        
%%  Populate_From_Collection
        
        function obj = Populate_From_Collection(obj, CollectionObject, CollectionFunction)

            %   Parse Inputs
            
            if nargin < 3 || isempty(CollectionFunction);   CollectionFunction = @datatables.curve;  end

            %   Ensure Function Handle
            
            if ischar(CollectionFunction);  CollectionFunction = str2func(CollectionFunction);  end
            
            %    Initialize Output

            obj = repmatc(obj, CollectionObject.Count, 1);

            %    Loop over Object

            for i = 1:numel(obj)
               obj(i) = CollectionFunction(CollectionObject.Item(i-1));
            end

        end
    end
    
    methods

    end
end