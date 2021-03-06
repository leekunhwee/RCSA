clc
clear
close all
%% flag
flag = 2; % Stiffness type

%% Parameters
Parameter = struct;
% Dynamics data
Parameter.Dynamic.f.x = [456.780432115313 1448.88914030656];
Parameter.Dynamic.zeta.x = [0.111705399393456 0.0170370095790783];
% Parameter.Dynamic.m.x = [0.963094248615537 0.177274003430936];
% Parameter.Dynamic.k.x = [7933097.18086825 14691778.4389479];
Parameter.Dynamic.shape.x = [1.01897987173574 2.37507579510009];

Parameter.Dynamic.f.y = [516.51818914797 1408.44814086966];
Parameter.Dynamic.zeta.y = [0.0245796327070992 0.0313576019295683];
% Parameter.Dynamic.m.y = [0.89006790971493 0.158418061422864];
% Parameter.Dynamic.k.y = [9374613.81193087 12406389.7145168];
Parameter.Dynamic.shape.y = [1.05995744178464 2.51245130218873];
% Simulation parameter
Parameter.Simulation.f_start = 0;       % Hz
Parameter.Simulation.f_end = 8000;  % Hz
Parameter.Simulation.df = 1;            % Hz
Parameter.Simulation.step_speed = 400;% steps of spindle speed
Parameter.Simulation.step_depth = 200;% steps of depth of cut

Parameter.Simulation.depth_st = 0e-3; % starting depth of cut (m) 
Parameter.Simulation.depth_fi = 6e-3;  % final depth of cut (m)
Parameter.Simulation.speed_st = 2e3;% starting spindle speed (rpm) Int.
Parameter.Simulation.speed_fi = 16e3; % final spindle speed (rpm)
% Cutting Coefficient
Parameter.CuttingCoef.Kt = 1319.4e6; % N/m^2
Parameter.CuttingCoef.Kr = 788.8e6;
% Tool geometry
Parameter.ToolGeo.Nt = 2;
Parameter.ToolGeo.D = 31.75;
% Cutting parameter
Parameter.Cutting.ae = Parameter.ToolGeo.D/2;
Parameter.Cutting.operation = -1; % -1 Downmilling ; 1 Upmilling 
% computational parameters 
Parameter.Calc.k = 40;% number of discretization interval over one period
Parameter.Calc.intk =20;% number of numerical integration steps for Equation (37)

Parameter.Calc.m = Parameter.Calc.k;% since time delay = time period
Parameter.Calc.wa = 1/2;% since time delay = time period
Parameter.Calc.wb = 1/2;% since time delay = time period

%% Plot Lobe
MultiSemi(Parameter.Dynamic,Parameter.Simulation,Parameter.CuttingCoef,Parameter.ToolGeo,Parameter.Cutting,Parameter.Calc)

%% Adjustment
axis([0 16000 0 6])
title('Stability of a milling process in time domain');
xlabel('\it\Omega \rm/ rpm')
ylabel('\itb_{lim} \rm/ mm')
set(gca,'FontSize', 11 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[28 5 13.53 9.03],'color','white');% word��13.5,9��
set(gca,'xtick',[2000 4000 6000 8000 10000 12000 14000 16000])
grid on