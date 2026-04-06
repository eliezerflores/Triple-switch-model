classdef HDSModel
    % a class defining your model system. It stores the ODEs, the switches,
    % parameter names and values
    properties ( Constant = true, Access = public ) % these properties will be publicly visible but unchangeable
        parameter_names = {'B_ex','P_ex','P_env','kappa_P','alpha_P','gamma_PB','delta_P','kappa_B','gamma_BB','gamma_BR','delta_B','kappa_A','gamma_AB','delta_A','kappa_D','delta_D'}
    end
    
    properties ( Access = public )
        parameters (1,16) {istable}

        % NEW: switch thresholds container
        switch_thresholds struct

        % Here are two switches for simplicity
        switch_1 {istable} = table ( 0, 1, 'VariableNames', {'off', 'on'} ) %R
        switch_2 {istable} = table ( 1, 2, 'VariableNames', {'off', 'on'} ) %K
        switch_3 {istable} = table ( 0, 1, 'VariableNames', {'off', 'on'} ) %T
        switch_4 {istable} = table ( 1, 2, 'VariableNames', {'off', 'on'} ) %G
    end
    
    methods ( Access = public )
        % constructor function
        function obj = HDSModel(parameter_values)

    obj.parameters = parameter_values;

    % --- Switch thresholds ---
    obj.switch_thresholds = struct();

    obj.switch_thresholds.sw1_minus = 0.2;
    obj.switch_thresholds.sw1_plus  = 0.8;

    obj.switch_thresholds.sw2_minus = 0.2;
    obj.switch_thresholds.sw2_plus  = 0.8;

    obj.switch_thresholds.sw3 = struct();
    obj.switch_thresholds.sw3.case1 = [0.8, 0.2]; % (0,0)
    obj.switch_thresholds.sw3.case2 = [0.7, 0.1]; % (0,1)
    obj.switch_thresholds.sw3.case3 = [0.9, 0.3]; % (1,0)
    obj.switch_thresholds.sw3.case4 = [0.75, 0.15]; % (1,1)

end    

        %% method to numerically integrate from an initial value. (solve initial value problem)
        [t, y, t_sw, y_sw] = solve_ivp(obj, t_sample, y0, sw0)
    end
    
    methods ( Access = private )
        % These methods are hidden from the user of the object to keep it
        % as simple as possible. You can still access them as normal for
        % debugging purposes.

        % this method keeps track of the events
        [value, isterminal, direction] = events_fun ( m, t, y, switch_states )
        
        dydt = diff_eqn ( m, t, y, switch_states )
        % jac  = jac_eqn  ( m, t, y, switch_states ) % again, you probably won't need to specify the jacobian, but here's where you'd do it.
    end

    methods
        function obj = set.parameters(obj, parameter_valuess)
            % set the parameters property. Every time we try to set the
            % parameter property, this "setting method" is called.

            n_parameters = length(obj.parameter_names);
            if isnumeric(parameter_valuess)
                if length(parameter_valuess)~=n_parameters % if the vector is of the wrong length
                    error('HDSModel:ParameterError','We expect %i parameters in the vector.', n_parameters)
                end
                obj.parameters = array2table(parameter_valuess, 'VariableNames', obj.parameter_names);
            elseif istable(parameter_valuess)
                % check the names of the parameters in the incoming table
                % all match up with those we expect in the parameter_names
                % property
                present = ismember(obj.parameter_names, parameter_valuess.Properties.VariableNames );
                if ( sum(present) ~= n_parameters ) % if not all parameters are accounted for
                    error('HDSModel:ParameterError',['Parameter(s) [', strjoin(m.parameter_names(~present),', '), '] did not appear in the parameter table you provided. Please provide these.']);
                end
                obj.parameters = parameter_valuess;
            else
                error('We expect parameters specified as either a vector or table.')
            end
        end
    end
end
