%% save_to_mat
% Saves metadata as .mat structure

%%
function save_to_mat(filename, par, txtPar, metaPar, metaData)
% created 2020/11/30 by Juan Francisco Robles

%% Syntax
% <../error_stats.m *error_stats*>(par, metaPar, data, metaData, txtData, txtPar) 

%% Description
% Plotes model predictions from calibration solutions
%
% Input
% 
% * par: structure with parameters of species
% * metaPar: structure with information on metaparameters
% * data: structure with data for species
% * auxData: structure with auxilliairy data that is required to compute predictions of data (e.g. temperature, food.). 
%   auxData is unpacked in predict and the user needs to construct predictions accordingly.
% * metaData: structure with information on the entry
% * txtData: structure with information on the data

%% Remarks
% Depending on <estim_options.html *estim_options*> settings:
% writes to results_my_pet.mat and/or results_my_pet.html, 
% plots to screen
% writes to report_my_pet.html and shows in browser
% Plots use lava-colour scheme; from high to low: white, red, blue, black.
% In grp-plots, colours are assigned from high to low.
% Since the standard colour for females is red, and for males blue, compose set with females first, then males.

global pets 

n_pets = length(pets);

% save results to result_group.mat or result_my_pet.mat
if n_pets > 1
    filenm   = ['results_group_', filename, '.mat']';
    save(filenm, 'par', 'txtPar', 'metaPar', 'metaData');
else % n_pets == 1
    filenm   = ['results_', filename, '.mat'];
    metaPar.MRE = metaPar.MRE;   metaPar.RE = metaPar.RE;
    metaPar.SMSE = metaPar.SMSE; metaPar.SSE = metaPar.SSE;
    save(filenm, 'par', 'txtPar', 'metaPar', 'metaData');
end
end