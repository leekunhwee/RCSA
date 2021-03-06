%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---------------Copyright------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jianhui Li                         %
% Time: 03/14/2019                           %
% University of British Columbia, BC, Canada %
% Affiliation:                               %
% Department of Mechanical Engineering       %
% Manufacturing Automation Laboratary        %
% E-mail: jianhui.li@alumni.ubc.ca           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Turning stability using semi-discrete time domain solution
% Reduce the dimension from 2(m+1) to m+2
clc
clear
% close all

%% Dynamic Parameters
% One DOF
zeta = 0.012;               % Damping ratio
k_t = 2.26e8;                 % Stiffness N/m 
theta = 30;                 % Orientation Deg
k_y = k_t/(cosd(theta)^2);    % Orientation Stiffness N/m 
wn = 250*2*pi;              % Natural Frequency rad/sec
K_f = 1e9;                  % Cutting Constant N/m2

%% Simulation Parameters
k =40;               % number of discretization interval over one period T
m = k;                % since time delay = time period
depth_st = 0e-3;    % Starting depth of cut(m)
depth_fi = 60e-3;   % Final depth of cut(m)
speed_st = 2e3;     % Starting spindle speed(rpm)
speed_fi = 14e3;    % Final spindle speed(rpm)
speed_step = 400;
depth_step = 200;

%% Initial conditions
I = eye(2);
% Initial the B1 and B2 matrix, Attention! Column and row
B1 = zeros(m+2,m+2);
B2 = zeros(m+2,m+2);
dia = ones(m+1,1);
dia(1:2)=0;
B1 = B1 + diag(dia,-1);
B1(3,1) = 1;

% Spindle Speed loop
for s = 1:speed_step+1
    n = speed_st+(s-1)*(speed_fi-speed_st)/speed_step;
    % Spindle period
    T = 60/n;
    % Discrete time number
    dt = T/k;
    % Cutting depth loop
    for d = 1:depth_step+1
        % Build the L and R matrix
        a = depth_st+(d-1)*(depth_fi-depth_st)/depth_step;
        L = [0, 1; -(wn^2)*(1+(K_f*a/k_y)), -2*zeta*wn];
        R = [0, 0; (wn^2)*K_f*a/k_y       , 0         ];

        % Define the first two Column and Row of B1
        B1(1:2,1:2) = expm(L*dt);   
        % Build the complete matrix of B2
        BEnd1 = 0.5*(expm(L*dt)-I)/L*R;
        BEnd2 = 0.5*(expm(L*dt)-I)/L*R;
        B2((1:2),(end))   = BEnd1(1:2,1);
        B2((1:2),(end-1)) = BEnd2(1:2,1);
        % Build the B matrix
        B = B1+B2;
        Fi = eye(m+2,m+2); 
        for i=1:m
            Fi = B*Fi;
        end
        ss(s,d)=n;
        dp(s,d)=a*1000;
        ei(s,d)=max(abs(eig(Fi)));
    end
    speed_step+1-s          % Process Display
end
%%
hold on
% figure 
contour(ss,dp,ei,[1, 1])
xlabel('Spindle speed [rev/min]');
ylabel('a_l_i_m [mm]');
title('Stability of a 1-DOF shaping process');
set(gcf,'unit','centimeters','position',[18 5 13.53 9.03],'color','white');%
set(gca,'FontSize', 10 ,'FontName', 'Times New Roman','xtick',[2000 4000 6000 8000 10000 12000 14000 16000])
axis([2000 15000 0 60])
grid on