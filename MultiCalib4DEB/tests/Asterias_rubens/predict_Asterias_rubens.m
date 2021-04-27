  %% predict_Asterias_rubens
% Obtains predictions, using parameters and data

%%
function [prdData, info] = predict_Asterias_rubens(par, data, auxData)
% created by Starrlight Augustine, Dina Lika, Bas Kooijman, Goncalo Marques and Laure Pecquerie 2015/01/30; 
% last modified 2015/07/29
  
%% Syntax
% [prdData, info] = <../predict_my_pet.m *predict_my_pet*>(par, data, auxData)
  
%% Description
% Obtains predictions, using parameters and data
%
% Input
%
% * par: structure with parameters (see below)
% * data: structure with data (not all elements are used)
% * auxData : structure with temp data and other potential environmental data
%  
% Output
%
% * prdData: structure with predicted values for data
% * info: identified for correct setting of predictions (see remarks)
  
%% Remarks
% Template for use in add_my_pet.
% The code calls <parscomp_st.html *parscomp_st*> in order to compute scaled quantities, compound parameters, molecular weights and compose matrices of mass to energy couplers and chemical indices.
% With the use of filters, setting info = 0, prdData = {}, return, has the effect that the parameter-combination is not selected for finding the best-fitting combination; this setting acts as customized filter.
  
%% Example of a costumized filter
% See the lines just below unpacking
  
  % unpack par, data, auxData
  cPar = parscomp_st(par); vars_pull(par); 
  vars_pull(cPar);  vars_pull(data);  vars_pull(auxData);
    
  % customized filters for allowable parameters of the standard DEB model (std)
  % for other models consult the appropriate filter function.
%   filterChecks = k * v_Hp >= f_tL^3 || ...         % constraint required for reaching puberty with f_tL
%                  ~reach_birth(g, k, v_Hb, f_tL);   % constraint required for reaching birth with f_tL
%   
%   if filterChecks  
%     info = 0;
%     prdData = {};
%     return;
%   end  
  T_pars = [T_A; T_L; T_AL];
  % compute temperature correction factors
  TC_ab = tempcorr(temp.ab, T_ref, T_pars);
  TC_aj = tempcorr(temp.aj, T_ref, T_pars);
  TC_GSI = tempcorr(temp.GSI, T_ref, T_pars);
  TC_LW = tempcorr(temp.LW, T_ref, T_pars);
  TC_L_JO =  tempcorr(temp.L_JO, T_ref, T_A);
  TC_L_JO_f0 =  tempcorr(temp.L_JO_f0, T_ref, T_A);
  TC_t_Le = tempcorr(temp.t_Le, T_ref, T_pars);

% uncomment if you need this for computing moles of a gas to a volume of gas
% - else feel free to delete  these lines
% molar volume of gas at 1 bar and 20 C is 24.4 L/mol
% T = C2K(20); % K, temp of measurement equipment- apperently this is
% always the standard unless explicitely stated otherwise in a paper (pers.
% comm. Mike Kearney).
% X_gas = T_ref/ T/ 24.4;  % M,  mol of gas per litre at T_ref and 1 bar;
  
% zero-variate data

  % life cycle
  pars_tj = [g k l_T v_Hb v_Hj v_Hp];
  [t_j, t_p, t_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, f);
  
  % initial
  pars_UE0 = [V_Hb; g; k_J; k_M; v]; % compose parameter vector
  U_E0 = initial_scaled_reserve(f, pars_UE0); % d.cm^2, initial scaled reserve
  Wd_0 = 1e6 * U_E0 * p_Am * w_E/ mu_E; % ug, initial dry weight
  
  % birth
  L_b  = L_m * l_b;                  % cm, structural length at birth at f
  Lw_b = L_b/ del_Mj;                % cm, total length at birth at f
  tT_b = t_b/ k_M/ TC_ab;            % d, age at birth at f and T

  % metam
  L_j  = L_m * l_j;                  % cm, structural length at metam
  Lw_j = L_j/ del_Mj;                 % cm, arm length after metam
  tT_j = t_j/ k_M/ TC_aj;            % d, time since birth at metam
  s_M = l_j/ l_b;                    % -, acceleration factor
   
  % puberty 
  L_p  = L_m * l_p;                  % cm, structural length at puberty at f
  Lw_p = L_p/ del_M;                 % cm, radius length at puberty at f
  Ww_p = L_p^3 * (1 + f * w);        % g,  wet weight at puberty.
 
  
  % GSI
  t1 = 365*0.83; % d, period of accumulaton of reprod buffer for 11 months. Timing depends on the location.
  e_GSI = 0.11 /(1-0.11)/w; % e, scaled reserves
  GSI = TC_GSI * (t1 * k_M * g/ e_GSI^3)/ (e_GSI + kap * g * y_V_E);
  GSI = GSI * ((1 - kap) * e_GSI^3 - k_M^2 * g^2 * k_J * U_Hp/ v^2/ s_M^3);

  % ultimate
  e_end = 0.15/(1-0.15)/w;  % this is the pi at the end of the spring experiment when this animals were taken from
  [t_j, t_p, t_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, e_end);
  L_i = L_m * l_i;                  % cm, ultimate structural length at f
  Lw_i = L_i/ del_M;                % cm, ultimate total length at f
  Ww_i = L_i^3 * (1 + e_end * w);       % g, ultimate wet weight does not include reproduction buffer.
  
  % pyloric index
  PI = 0.9*w / (1+0.9*w);

  % pack to output
  prdData.ab = tT_b;
  prdData.aj = tT_j;
  prdData.Lb = Lw_b*10; %cm to mm
  prdData.Lj = Lw_j*10; %cm to mm
  prdData.Lp = Lw_p;
  prdData.Li = Lw_i;
  prdData.Wd0 = Wd_0;
  prdData.Wwp = Ww_p;
  prdData.Wwi = Ww_i;
  prdData.GSI = GSI;
  prdData.PI = PI;
  
  % uni-variate data
  
  % length-weight
  L = LW(:,1) * del_M;
  EWw = L.^3 * (1 + e_end * w);                   % g, expected wet weight at time

  % Respiration
  
  pars_pow = [kap; kap_R; g; k_J; k_M; L_T; v; U_Hb; U_Hj; U_Hp];
  L = L_JO(:,1) .* del_M;           % cm, structural length
  p_ref = p_Am * L_m^2;             % max assimilation ower at max size
  O2M = (- n_M\n_O)';               % -, matrix that converts organic to mineral fluxes  O2M is prepared for post-multiplication eq. 4.35
  pACSJGRD = p_ref * scaled_power_j(L, 0.8, pars_pow, l_b, l_j, l_p); % f assumed to be 0.5 as animals were fed once every 5 days.
  pADG = pACSJGRD(:, [1 7 5]); pADG(:,1) = 1 * p_Am * s_M .* L.^2 ;      % power contributions, assimilation assumed maximum, right after feeding.
  JO = pADG * eta_O';             % organic fluxes
  JM = JO * O2M;                  % mineral fluxes
  EJO = - 32e3 * JM(:,3) .* TC_L_JO;% mg/hour specific dioxygen consumption rate at temp T
  
  L = L_JO_f0(:,1) .* del_M;        % cm, structural length
  pACSJGRD = p_ref * scaled_power_j(L, 0.4, pars_pow, l_b, l_j, l_p);
  pADG = pACSJGRD(:, [1 7 5]); pADG(:,1) = 0; % exclude contribution from assim
  JO = pADG * eta_O';             % organic fluxes
  JM = JO * O2M;                  % mineral fluxes
  EJO_f0 = - 32e3 * JM(:,3) .* TC_L_JO_f0;  %  mg/day, specific dioxygen consumption rate at temp T


  %   starvation
%   pi = 0.08;  % -, pyloric caeca index at the begining of the experiment, just after spawning is over, no E_R and gonad
%   e0 = pi/(1-pi)/w ; % assuming a very small Er, june is right at the end of spawning season, no Er in pyloric caeca
%   V =  8.22/(1+e0*w);  % cm3, structural volume from weight, as lengths are not very good at this case (3.5*del_M)^3; %.
%   pars_starve = [kap; k_J; g; L_m; L_T; T_ref; T_A; s_M; U_Hp; p_Am; v; E_G];
%   VRE_0 = [V; 0; e0* E_m * V];
%   t_T = [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50; % days since onset gametogenesis
%         284.15	284.55	283.85	284.15	285.25	285.55	285.75	286.15	286.85	287.15	287.45	287.35	287.85	288.15	288.35	288.15	288.85	289.35	290.15	289.55	289.55	289.15	287.95	291.05	290.85	290.65	290.65	290.85	290.35	290.35	290.65	290.35	291.15	291.15	290.45	290.35	290.65	291.25	290.85	291.15	291.95	290.75	290.45	290.65	290.75	290.85	290.35	289.55	289.65	290.05]; % K, temperature
%   [a VRE] = ode45(@dget_VRE, [t_Ww_f0(:,1)], VRE_0, [], pars_starve, t_T, 0);
%   
%   EWw_f0 = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;
  
   %%   Length, Weight and feeding rate during the experiments at several food levels
    %%   Spring experiment:
          pi = 0.08;  % -, pyloric caeca index at the begining of the experiment, just after spawning is over, no E_R or gonad
          e0 = pi/(1-pi)/w ; % assuming a very small Er, june is right at the end of spawning season, no Er in pyloric caeca
          V = 7.77/(1+e0*w);  % cm3, structural volume from weight, as lengths are not very good at this case (3.5*del_M)^3; %.
          pars_starve = [kap; k_J; g; L_m; L_T; T_ref; s_M; U_Hp; p_Am; v; E_G];
          VRE_0 = [V; 0; e0* E_m * V];
          t_T = [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50; % days since onset gametogenesis
                284.15	284.55	283.85	284.15	285.25	285.55	285.75	286.15	286.85	287.15	287.45	287.35	287.85	288.15	288.35	288.15	288.85	289.35	290.15	289.55	289.55	289.15	287.95	291.05	290.85	290.65	290.65	290.85	290.35	290.35	290.65	290.35	291.15	291.15	290.45	290.35	290.65	291.25	290.85	291.15	291.95	290.75	290.45	290.65	290.75	290.85	290.35	289.55	289.65	290.05]; % K, temperature
          TN=csapi(t_T(1,:),t_T(2,:),t_JX_N16(:,1));
          TC_t_JX_N =tempcorr(TN, T_ref, T_pars); % all food levels share the same temperatures and recordings at the same time
          tX = [1; t_JX_N16(:,1)];
          % food level N=16=12.8817gAFDW/m2
          X = 12.8817/w_X;  % mol/m2, food density
          fN16 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N16(:,1)], VRE_0, [], pars_starve, T_pars, t_T, fN16);
          EWw_N16 = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N16 = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve, T_pars, t_T, fN16);
          VRE = VRE(2:end,:);
          EJX_N16 = TC_t_JX_N * J_X_Am * s_M * w_X * fN16 .*  VRE(:,1).^(2/3);

            % food level N=8=6.4406gAFDW/m2
          X = 6.4406/w_X;  % mol/m2, food density
          fN08 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N08(:,1)], VRE_0, [], pars_starve,T_pars, t_T, fN08);
          EWw_N08 = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N08 = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve, T_pars, t_T, fN08);
          VRE = VRE(2:end,:);
          EJX_N08 = TC_t_JX_N * J_X_Am * s_M * w_X * fN08.*  VRE(:,1).^(2/3);

              % food level N=4=3.2198gAFDW/m2
          X = 3.2198/w_X;  % mol/m2, food density
          fN04 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N04(:,1)], VRE_0, [], pars_starve,T_pars, t_T, fN04);
          EWw_N04 = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N04 = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve,T_pars, t_T, fN04);
          VRE = VRE(2:end,:);
          EJX_N04 = TC_t_JX_N * J_X_Am * s_M * w_X * fN04.*  VRE(:,1).^(2/3);

                % food level N=2=1.6075gAFDW/m2
          X = 1.6075/w_X;  % mol/m2, food density
          fN02 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N02(:,1)], VRE_0, [], pars_starve,T_pars, t_T, fN02);
          EWw_N02 = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N02 = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve, T_pars, t_T, fN02);
          VRE = VRE(2:end,:);
          EJX_N02 = TC_t_JX_N * J_X_Am * s_M * w_X * fN02.*  VRE(:,1).^(2/3);

          % Larval development
          pars_tj = [g k l_T v_Hb v_Hj v_Hp];
          f=0.8;
          [t_j, t_p, t_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, f);
          
    %% Autumn Experiment
          pi = 0.025;  % -, pyloric caeca index at the begining of the experiment, it has been corrected assuming half of the PW was Er.
          e0 = pi/(1-pi)/w ; % assuming a very small Er, june is right at the end of spawning season, no Er in pyloric caeca
          V = 7.58/(1+e0*w);  % cm3, structural volume from weight, as lengths are not very good at this case (3.5*del_M)^3; %.
          R = 0.1828 * d_E * mu_E / w_E; % J, accumulated Er at the start of the experiment
          VRE_0 = [V; R; e0* E_m * V];
          pars_starve = [kap; k_J; g; L_m; L_T; T_ref; s_M; U_Hp; p_Am; v; E_G];
          t_T_A = [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70; % days since onset gametogenesis
                289.35	288.55	288.05	287.75	288.05	286.35	285.35	284.85	283.95	284.25	283.15	283.25	282.85	282.75	282.25	281.95	281.85	281.45	282.45	282.45	282.45	282.85	282.85	281.55	281.15	281.15	281.05	281.25	281.25	281.65	281.85	284.65	285.25	284.25	283.85	283.25	283.15	282.85	280.65	281.35	280.65	280.15	280.45	280.65	280.45	279.45	279.85	282.25	280.55	281.65	280.45	280.95	280.15	280.25	276.65	277.65	277.75	277.45	278.05	277.45	277.35	277.35	277.65	277.85	278.15	277.65	277.75	277.65	277.35	277.75]; % K, temperature
          TN=csapi(t_T_A(1,:),t_T_A(2,:),t_JX_N16_A(:,1));
          TC_t_JX_N_A =tempcorr(TN, T_ref, T_pars); % all food levels share the same temperatures and recordings at the same time
          tX = [1; t_JX_N16_A(:,1)];
          % food level N=16=10.1062gAFDW/m2
          X = 10.1062/w_X;  % mol/m2, food density
          fN16 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N16_A(:,1)], VRE_0, [], pars_starve,T_pars, t_T_A, fN16);
          EWw_N16_A = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N16_A = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve, T_pars, t_T_A, fN16);
          VRE = VRE(2:end,:);
          EJX_N16_A = TC_t_JX_N_A * J_X_Am * s_M * w_X * fN16 .*  VRE(:,1).^(2/3);

            % food level N=8=5.0529gAFDW/m2
          X = 5.0529/w_X;  % mol/m2, food density
          fN08 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N08_A(:,1)], VRE_0, [], pars_starve,T_pars,  t_T_A, fN08);
          EWw_N08_A = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N08_A = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve,T_pars, t_T_A, fN08);
          VRE = VRE(2:end,:);
          EJX_N08_A = TC_t_JX_N_A * J_X_Am * s_M * w_X * fN08.*  VRE(:,1).^(2/3);

              % food level N=4=2.5261gAFDW/m2
          X = 2.5261/w_X;  % mol/m2, food density
          fN04 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N04_A(:,1)], VRE_0, [], pars_starve, T_pars,t_T_A, fN04);
          EWw_N04_A = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N04_A = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve,T_pars, t_T_A, fN04);
          VRE = VRE(2:end,:);
          EJX_N04_A = TC_t_JX_N_A * J_X_Am * s_M * w_X * fN04.*  VRE(:,1).^(2/3);

                % food level N=2=1.264gAFDW/m2
          X = 1.264/w_X;  % mol/m2, food density
          fN02 = X/(K + X); % -, scaled functional response
          [a VRE] = ode45(@dget_VRE, [t_Ww_N02_A(:,1)], VRE_0, [], pars_starve, T_pars, t_T_A, fN02);
          EWw_N02_A = VRE(:,1)+ (VRE(:,3)+ VRE(:,2))* w_E ./ d_E /mu_E;   %g, wet weight at time
          ELw_N02_A = VRE(:,1).^(1/3) ./ del_M; % cm, arm length at time

          [a VRE] = ode45(@dget_VRE, tX, VRE_0, [], pars_starve, T_pars, t_T_A, fN02);
          VRE = VRE(2:end,:);
          EJX_N02_A = TC_t_JX_N_A * J_X_Am * s_M * w_X * fN02.*  VRE(:,1).^(2/3);

   %% Larval development
          pars_tj = [g k l_T v_Hb v_Hj v_Hp];
          f=0.5;
          [t_j, t_p, t_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, f);
  
          %time-length data for larva f=1
          tT_b = t_b/ k_M/ TC_t_Le;     % time of birth at T and f
          L_b =  l_b * L_m;                % scaled length at birth, both T and f are the same than in zero-var.
          Lw_b = L_b /del_Mj;              % length at birth at T and f
          rT_j = TC_t_Le * rho_j * k_M; % exponential growth constant
          ELe = 10 * Lw_b * exp((t_Le(:,1) - tT_b) * rT_j/ 3);  % mm, length of larva


  % pack to output
  % the names of the fields in the structure must be the same as the data names in the mydata file
  prdData.LW = EWw;
  prdData.L_JO = EJO;
  prdData.L_JO_f0 = EJO_f0;
  prdData.t_Le = ELe;
%   prdData.t_Ww_f0=EWw_f0;
  prdData.t_Ww_N16=EWw_N16;
  prdData.t_Lw_N16=ELw_N16;
  prdData.t_JX_N16=EJX_N16;
  prdData.t_Ww_N08=EWw_N08;
  prdData.t_Lw_N08=ELw_N08;
  prdData.t_JX_N08=EJX_N08;
  prdData.t_Ww_N04=EWw_N04;
  prdData.t_Lw_N04=ELw_N04;
  prdData.t_JX_N04=EJX_N04;
  prdData.t_Ww_N02=EWw_N02;
  prdData.t_Lw_N02=ELw_N02;
  prdData.t_JX_N02=EJX_N02;
  prdData.t_Ww_N16_A=EWw_N16_A;
  prdData.t_Lw_N16_A=ELw_N16_A;
  prdData.t_JX_N16_A=EJX_N16_A;
  prdData.t_Ww_N08_A=EWw_N08_A;
  prdData.t_Lw_N08_A=ELw_N08_A;
  prdData.t_JX_N08_A=EJX_N08_A;
  prdData.t_Ww_N04_A=EWw_N04_A;
  prdData.t_Lw_N04_A=ELw_N04_A;
  prdData.t_JX_N04_A=EJX_N04_A;
  prdData.t_Ww_N02_A=EWw_N02_A;
  prdData.t_Lw_N02_A=ELw_N02_A;
  prdData.t_JX_N02_A=EJX_N02_A;
  
  
  