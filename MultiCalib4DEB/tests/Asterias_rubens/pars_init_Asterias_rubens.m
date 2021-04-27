%% pars_init_my_pet
% sets (initial values for) parameters

%%
function [par, metaPar, txtPar] = pars_init_Asterias_rubens(metaData)
  % created by Starrlight Augustine, Dina Lika, Bas Kooijman, Goncalo Marques and Laure Pecquerie 2015/03/31
  % modified 2015/07/29 by Starrlight 
  
  %% Syntax
  % [par, metaPar, txtPar] = <../pars_init_my_pet.m *pars_init_my_pet*>(metaData)
  
  %% Description
  % sets (initial values for) parameters
  %
  % Input
  %
  % * metaData: structure with info about this entry (needed for names of
  %   phylum and class to get d_V)
  %  
  % Output
  %
  % * par : structure with values of parameters
  % * metaPar: structure with information on metaparameters
  % * txtPar: structure with information on parameters

% parameters: initial values at reference temperature T_ref
% model type : see online manual for explanation and alternatives 
% be aware that each model type is associated with a specific list of core
% primary parameters. Those listed here are for model 'std'. See the manual
% for parameters associated with the other model types.
metaPar.model = 'abj'; 

% edit the values below such that predictions are not too far off;
% the values must be set in the standard DEB units:
%   d for time; cm for length; J for energy; K for temperature

% reference parameter (not to be changed)
par.T_ref = C2K(20); free.T_ref = 0; units.T_ref = 'K';        label.T_ref = 'Reference temperature';

%% core primary parameters
par.z     = 1.193 ; free.z     = 1;   units.z     = '-';        label.z     = 'zoom factor'; %for z = 1: L_m = 1 cm
par.F_m   = 0.01364;   free.F_m   = 1;   units.F_m   = 'm^2/d.cm^2'; label.F_m   = '{F_m}, max spec searching rate';
par.kap_X = 0.8479;   free.kap_X = 1;   units.kap_X = '-';        label.kap_X = 'digestion efficiency of food to reserve';
par.kap_P = 0.1;   free.kap_P = 0;   units.kap_P = '-';        label.kap_P = 'faecation efficiency of food to faeces';
par.v     = 0.0548;  free.v     = 1;   units.v     = 'cm/d';     label.v     = 'energy conductance';
par.kap   = 0.8048;   free.kap   = 1;   units.kap   = '-';        label.kap   = 'allocation fraction to soma';
par.kap_R = 0.95;  free.kap_R = 0;   units.kap_R = '-';        label.kap_R = 'reproduction efficiency';
par.p_M   = 21.71;  free.p_M   = 1;   units.p_M   = 'J/d.cm^3'; label.p_M   = '[p_M], vol-spec somatic maint';
par.p_T   =  0;    free.p_T   = 0;   units.p_T   = 'J/d.cm^2'; label.p_T   = '{p_T}, surf-spec somatic maint';
par.k_J   = 0.002; free.k_J   = 0;   units.k_J   = '1/d';      label.k_J   = 'maturity maint rate coefficient';
par.E_G   = 2273;  free.E_G   = 1;   units.E_G   = 'J/cm^3';   label.E_G   = '[E_G], spec cost for structure';
par.E_Hb  = .003771;  free.E_Hb  = 1;   units.E_Hb  = 'J';        label.E_Hb  = 'maturity at birth';
par.E_Hj  = 3.774;   free.E_Hj  = 1;   units.E_Hj  = 'J';        label.E_Hj  = 'maturity at birth';
par.E_Hp  = 3548;  free.E_Hp  = 1;   units.E_Hp  = 'J';        label.E_Hp  = 'maturity at puberty';
par.h_a   = 1e-6;  free.h_a   = 0;   units.h_a   = '1/d^2';    label.h_a   = 'Weibull aging acceleration';
par.s_G   = 1e-4;  free.s_G   = 0;   units.s_G   = '-';        label.s_G   = 'Gompertz stress coefficient';

%% auxiliary parameters
par.T_A   = 6146;  free.T_A   = 1;    units.T_A = 'K';        label.T_A = 'Arrhenius temperature';
par.T_L   = 232.3;  free.T_L   = 1;    units.T_L = 'K';        label.T_L = 'Lower limit temperature ';
par.T_AL   = 4145;  free.T_AL   = 1;    units.T_AL = 'K';        label.T_AL = 'Arrhenius temperature at lower limit';

par.del_M = 0.5071;  free.del_M = 1;    units.del_M = '-';      label.del_M = 'shape coefficient';
par.del_Mj = 0.5538; free.del_Mj = 1;    units.del_Mj = '-';      label.del_Mj = 'shape coefficient';

%% environmental parameters (temperatures are in data)
par.f = 0.8;       free.f     = 0;    units.f = '-';          label.f    = 'scaled functional response for 0-var data';

%% set chemical parameters from Kooy2010 
%  don't change these values, unless you have a good reason
[par, units, label,free] = addchem(par, units, label, free, metaData.phylum, metaData.class);

% par.d_V = 0.07;  free.d_V = 0;    units.d_V = 'g/cm^3';      label.d_V = 'specific density of structure';
% par.d_E = 0.2;   free.d_E = 0;    units.d_E = 'g/cm^3';      label.d_E = 'specific density of reserves';



% if you do have a good reason you may overwrite any of the values here, but please provide an explanations. 
% For example:
% par.d_V = 0.33;     % g/cm^3, specific density of structure, see ref bibkey
% par.d_E = par.d_V; % g/cm^3, specific density of reserve
%   or alternatively you might want to add a product D like:
% par.d_D = 0.1;     free.d_D = 0;  units.d_D  = 'g/cm^3'; label.d_D  = 'specific density of product';        
% par.mu_D = 273210; free.mu_D = 0; units.mu_D = 'J/mol';  label.mu_D = 'chemical potential of product';      
% par.n_CD = 1;      free.n_CD = 0; units.n_CD = '-';      label.n_CD = 'chem. index of carbon in product';   
% par.n_HD = 1.2;      free.n_HD = 0; units.n_HD = '-';      label.n_HD = 'chem. index of hydrogen in product'; 
% par.n_OD = 0.55;   free.n_OD = 0; units.n_OD = '-';      label.n_OD = 'chem. index of oxygen in product';   
% par.n_ND = 0.1;    free.n_ND = 0; units.n_ND = '-';      label.n_ND = 'chem. index of nitrogen in product'; 

%% estimating chemical parameters (remove these remarks after editing the file)
% in some cases the data allow for estimating some of the chemical
% parameters. For example:
% free.mu_V = 1; 
% free.d_E  = 1;


%% Pack output:
txtPar.units = units; txtPar.label = label; par.free = free; 

