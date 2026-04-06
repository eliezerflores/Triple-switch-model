function [value,isterminal,direction] = events_fun(obj, t, y, switch_states)
% function to detect events of interest in our simulations, such as switch
% changes, or forced changes such to switch states at specified times

% ODE parameters
% a  = obj.parameters.a;
% b  = obj.parameters.b;
% c  = obj.parameters.c;
% d  = obj.parameters.d;

P_env     = obj.parameters.P_env;
P_ex      = obj.parameters.P_ex;
B_ex      = obj.parameters.B_ex;
kappa_P   = obj.parameters.kappa_P;
alpha_P   = obj.parameters.alpha_P;
gamma_PB  = obj.parameters.gamma_PB;
delta_P   = obj.parameters.delta_P;
kappa_B   = obj.parameters.kappa_B;
gamma_BB  = obj.parameters.gamma_BB;
gamma_BR  = obj.parameters.gamma_BR;
delta_B   = obj.parameters.delta_B;
kappa_A   = obj.parameters.kappa_A;
gamma_AB  = obj.parameters.gamma_AB;
delta_A   = obj.parameters.delta_A;
kappa_D   = obj.parameters.kappa_D;
delta_D   = obj.parameters.delta_D;

% Access thresholds from object
sw_1_minus = obj.switch_thresholds.sw1_minus;
sw_1_plus  = obj.switch_thresholds.sw1_plus;

sw_2_minus = obj.switch_thresholds.sw2_minus;
sw_2_plus  = obj.switch_thresholds.sw2_plus;

% sw3 depends on switch states
if switch_states(1)==false && switch_states(2)==false
    vals = obj.switch_thresholds.sw3.case1;

elseif switch_states(1)==false && switch_states(2)==1
    vals = obj.switch_thresholds.sw3.case2;

elseif switch_states(1)==1 && switch_states(2)==false
    vals = obj.switch_thresholds.sw3.case3;

elseif switch_states(1)==1 && switch_states(2)==1
    vals = obj.switch_thresholds.sw3.case4;
end

sw_3_minus = vals(1);
sw_3_plus  = vals(2);

%% calculate the threshold value and direction of change for each switch.
if switch_states(1)==false %RK-switch
    sw_1_switching_value = y(1) - sw_1_plus;
    sw_1_direction = 1; % stop only if going in positive direction
    sw_1_isterminal = 1; % we always set these to 1, so that the solver stops after each switch transition to record what happened
else
    sw_1_switching_value = y(1) - sw_1_minus;
    sw_1_direction = -1; % stop only if going in negative direction
    sw_1_isterminal = 1;
end

if switch_states(2)==false %T-switch
    sw_2_switching_value = y(4) - sw_2_plus;
    sw_2_direction = 1; % stop only if going in positive direction
    sw_2_isterminal = 1; % we always set these to 1, so that the solver stops after each switch transition to record what happened
else
    sw_2_switching_value = y(4) - sw_2_minus;
    sw_2_direction = -1; % stop only if going in negative direction
    sw_2_isterminal = 1;
end

if switch_states(3)==false %G-switch
    sw_3_switching_value = y(2) - sw_3_plus;
    sw_3_direction = -1; % stop only if going in positive direction
    sw_3_isterminal = 1;
else
    sw_3_switching_value = y(2) - sw_3_minus;
    sw_3_direction = 1; % stop only if going in negative direction
    sw_3_isterminal = 1;
end

% value: the threshold value(s) for each switch.
value = [sw_1_switching_value, sw_2_switching_value, sw_3_switching_value];

% isterminal: 1 = do stop. 0 = don't stop. We always set this to be 1 since
% we need to stop to recalculate the switch thresholds
isterminal = [sw_1_isterminal, sw_2_isterminal, sw_3_isterminal];

% direction: which direction of crossing are we interested in detecting.
% 1 = increasing, -1 = decreasing, 0 = either direction.
direction = [sw_1_direction, sw_2_direction, sw_3_direction];
end