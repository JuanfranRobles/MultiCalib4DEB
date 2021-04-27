%% <../run.m *run*>
% created by Starrlight Augustine, Bas Kooijman, Dina Lika, Goncalo Marques and Laure Pecquerie 2015/01/22
% modified 2015/03/25

%clear all; 
global pets

% species names
pets = {'Asterias_rubens'};

% See estim_options for more options
estim_options('default'); % runs estimation, uses nmregr method and filter
                          % prints results, does not write file, does not produce html
% 'method':           'nm' - use Nelder-Mead method (default); 'no' - do not estimate;
% 'pars_init_method': 0 - get initial estimates from automatized computation (default)
%                     1 - read initial estimates from .mat file 
%                     2 - read initial estimates from pars_init file 
% 'results_output':   0 - prints results to screen; (default)
%                     1 - prints results to screen, saves to .mat file and writes .html file; 
%                     2 - saves to .mat file and writes .html file
%                     (prints results to screen using a customized results file when there is one)

%estim_options('max_step_number',15e3); % set options for parameter estimation
%estim_options('max_fun_evals',10e3);  % set options for parameter estimation

estim_options('pars_init_method',2);
estim_options('results_output', 1);
estim_options('method', 'nm');

estim_pars; % run estimation