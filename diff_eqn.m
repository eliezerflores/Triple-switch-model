function dydt = diffEqn ( obj, t, y, switch_states )
% define the differential equations of your model

% ODE parameters
B_ex      = obj.parameters.B_ex;
P_ex      = obj.parameters.P_ex;
P_env     = obj.parameters.P_env;
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

% calculate the value of each switch given their current states.
% we pass in the table defining the switch values as the first argument.
R = sw_1_fun(obj.switch_1, switch_states(1));
K = sw_2_fun(obj.switch_2, switch_states(1));
T = sw_3_fun(obj.switch_3, switch_states(2));
G = sw_4_fun(obj.switch_4, switch_states(3));


% for simplicity, I'm defining a 2*2 linear differential equation with the
% switches sw_1 and sw_2 added as a vector to the end.
% dydt = [a, b;
%         c, d] * y + [e*sw_1;
%                      f*sw_2];

dydt = [ (P_env + P_ex) * kappa_P / ( 1 + gamma_PB * y(2) ) - alpha_P * y(3) * y(1) - delta_P * y(1); %Pathogens y(1)
    kappa_B * 1 / (1 + gamma_BB * y(2) ) * 1 / (1 + gamma_BR * R ) * G - delta_B * K * y(2) - B_ex * y(2); %Barrier y(2)
    kappa_A * 1 / (1 + gamma_AB * y(2) ) * G - delta_A * y(3);%AMPs y(3)
    kappa_D * R - delta_D * y(4) ];%Dendritic Cells y(4)
end

%modify here
function sw_value = sw_1_fun (switch_1, sw_state )
% function which looks for the value of the switch given it's current state
if sw_state == false
    sw_value = switch_1.off;
else
    sw_value = switch_1.on;
end
end

function sw_value = sw_2_fun(switch_2, sw_state )
% function which looks for the value of the switch given it's current state
if sw_state == false
    sw_value = switch_2.off;
else
    sw_value = switch_2.on;
end
end

function sw_value = sw_3_fun(switch_3, sw_state )
% function which looks for the value of the switch given it's current state
if sw_state == false
    sw_value = switch_3.off;
else
    sw_value = switch_3.on;
end
end

function sw_value = sw_4_fun(switch_4, sw_state )
% function which looks for the value of the switch given it's current state
if sw_state == false
    sw_value = switch_4.off;
else
    sw_value = switch_4.on;
end
end
