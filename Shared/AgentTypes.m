classdef AgentTypes
    %AgentTypes Matlab object of land disturbance agent types
    
    properties
        agentstable = table(categorical(...
            {'harvest', 'mechanical', 'insect', 'debris', 'hydrology', 'fire', 'other'})', ...
            [11 12 21 22 23 30 40]',...
            'VariableNames',{'name','code'});
        code = [];
        name = [];
    end
    
    
    methods
        function obj = AgentTypes(code_or_name)
            if ~isempty(code_or_name)
                %   Land disturbance agent types
                if isnumeric(code_or_name) % num means CODE of disturbance agent
                    % return the name of disturbance agents
                    obj.code = code_or_name;
                    [~, ids] = ismember(code_or_name, obj.agentstable.code);
                    obj.name = obj.agentstable.name(ids);
                else % else will be the NAME of disturbance agent
                    obj.name = code_or_name;
                    [~, ids] = ismember(categorical(lower(code_or_name)), lower(obj.agentstable.name)); % in categorical
                    obj.code = obj.agentstable.code(ids);
                end
            else
                obj.name = obj.agentstable.name;
                obj.code = obj.agentstable.code;
            end
        end
        
        function outputArg = getNames(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function outputArg = getCodes(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end