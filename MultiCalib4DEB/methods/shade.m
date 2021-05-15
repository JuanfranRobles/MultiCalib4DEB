%% lshade
% Finds parameter values for a pet that minimizes the lossfunction using the 
% Succes History Adaptation of Differential Evolution (SHADE) using a filter
%%
function [q, info, solution_set, bsf_fval] = shade(func, par, data, auxData, weights, filternm)
   % created 2020/02/15 by Juan Francisco Robles; 
   % modified 2020/02/17 by Juan Francisco Robles, 2020/02/20, 2020/02/21,
   % 2020/02/24, 2020/02/26, 2020/02/27, 2021/01/14, 2021/03/12,
   % 2021/03/22, 2021/05/11
   %   

   %% Syntax
   % [q, info, archive, bsf_fval] = <../lshade.m *lshade*> (func, par, data, auxData, weights, filternm)

   %% Description
   % Finds parameter values for a pet that minimizes the lossfunction using the 
   % SHADE multimodal algorithm using a filter.
   % The filter gives always a pass in the case that no filter has been selected 
   % in <estim_options.html *estim_options*>.
   % The values for SHADE initialization can be modifyed by editing the file
   % <calibration_options.html> *calibration_options*>
   %
   % Input
   %
   % * func: character string with name of user-defined function;
   %      see nrregr_st or nrregr  
   % * par: structure with parameters
   % * data: structure with data
   % * auxData: structure with auxiliary data
   % * weights: structure with weights
   % * filternm: character string with name of user-defined filter function
   %  
   % Output
   % 
   % * q: structure with parameters, result of the algorithm
   % * info: 1 if convergence has been successful; 0 otherwise
   % * archive: the set of solutions found by the multimodal algorithm
   % * bsf_fval: the best fitness value found

   %% Remarks
   % Set options with <calibration_options.html *calibration_options*>.
   % The number of fields in data is variable.
   %%%%%%%%%%%%%%%%%%%
   %% This package is a MATLAB/Octave source code of SHADE which is an improved version of SHADE 1.1.
   %% 
   %% The original code of this algorithm was taken from: https://sites.google.com/site/tanaberyoji/software
   %%
   %% Note that this source code is transferred from the C++ source code version.
   %% About SHADE, please see following papers:
   %%
   %% * Ryoji Tanabe and Alex Fukunaga: Success-History Based Parameter Adaptation for Differential Evolution, Proc. IEEE Congress on Evolutionary Computation (CEC-2013).
   %%
   %%%%%%%%%%%%%%%%%%% 

   global num_results lossfunction max_fun_evals num_runs refine_initial  
   global pop_size refine_running refine_run_prob refine_best refine_firsts
   global verbose verbose_options random_seeds max_calibration_time

   % Option settings
   % initiate info setting
   info = struct;
   info.run = struct;
   
   fileLossfunc = ['lossfunction_', lossfunction];
   format long;
   format compact;
   
   %% Taking data for objective function
   st = data;
   [nm, nst] = fieldnmnst_st(st); % nst: number of data sets

   for i = 1:nst   % makes st only with dependent variables
      fieldsInCells = textscan(nm{i},'%s','Delimiter','.');
      auxVar = getfield(st, fieldsInCells{1}{:});   % data in field nm{i}
      k = size(auxVar, 2);
      if k >= 2
         st = setfield(st, fieldsInCells{1}{:}, auxVar(:,2));
      end
   end

   % Y: vector with all dependent data
   % W: vector with all weights
   [Y, meanY] = struct2vector(st, nm);
   W = struct2vector(weights, nm);

   %% Getting parameters and setting objectives
   parnm = fieldnames(par.free); % Get free parameters names
   np = numel(parnm); % Get number of free parameters
   n_par = sum(cell2mat(struct2cell(par.free)));

   if (n_par == 0) % no parameters to iterate
      fprintf('There are not parameters to iterate. Finishing the calibration process \n');
      return; 
   end

   index = 1:np; % Get indexes of these free parameters which can be modifyed
   index = index(cell2mat(struct2cell(par.free)) == 1);
   free = par.free; % free is here removed, and after execution added again

   %% Auxiliary variables for function evaluation
   q = rmfield(par, 'free'); % copy input parameter matrix into output
   qvec = cell2mat(struct2cell(q));
   pen_val = 1e10;

    %% Population size
   pop_size = num_results;
   
   %%  Parameter settings for SHADE
   problem_size = length(index);
   max_nfes = max_fun_evals;
   ls_nfes = max_nfes * 0.7; 
   p_best_rate = 0.11;
   arc_rate = 1.5;
   memory_size = problem_size;

   %% Result file variables 
   solution_set.NP = pop_size;
   solution_set.pop = zeros(0, problem_size);
   solution_set.funvalues = zeros(0, 1); 
   solution_set.parnames = parnm(index); % Calibrated parameter names
   
   %% Take initial time
   time_start = tic;
   
   %% Runs loop
   fprintf('Launching calibration. \n');
   fprintf('Using SHADE multimodal algorithm. \n');
   fprintf('Total calibration runs: %d \n', num_runs);
   if max_fun_evals ~= Inf
      fprintf('Calibration defined with evaluations as stop criteria \n');
      fprintf('The total number of evaluations is: %d for each run \n', max_fun_evals);
      fprintf('The total number of evaluations for the whole calibration is %d \n', max_fun_evals * num_runs);
   else
      fprintf('Calibration defined with time as stop criteria \n');
      fprintf('The total calibration time is: %d minutes for each run \n', max_calibration_time);
      fprintf('The total calibration time for the whole calibration is %d minutes \n', max_calibration_time * num_runs);
   end
   for run = 1:(min(num_runs, length(random_seeds)))
      %% Take run initial time
      run_time_start = tic; 
      fprintf('Run %d. \n', run);
      % Initializing random number generator.
      rng(random_seeds(run), 'twister'); 
      
      %% Archive file variables
      archive.NP = arc_rate * pop_size; % maximum size of the archive
      archive.pop = zeros(0, problem_size); % solutions to store in the archive
      archive.funvalues = zeros(0, 1); % function value for the archived solutions
      
      %% Initialize the main population
      [popold, ranges] = gen_individuals(func, par, data, auxData, filternm); 
      disp('Ranges');
      disp(ranges);
      % Add refined guest if setted into calibration options
      if refine_initial
         fprintf('Launching local search over initial individual \n');
         first = 1;
         better = 1;
         aux = par;
         while better || first
            [guest, ~, aux_fval] = local_search('predict_pets', aux, ..., 
                                                data, auxData, weights, ...,
                                                filternm);
            guest = rmfield(guest, 'free');
            gvec = cell2mat(struct2cell(guest));
            aux = cell2struct(num2cell(gvec, np), parnm);
            aux.free = free;
            if first
               aux_best = aux_fval;
               first = 0; % Stop first criteria
            else
               if (1.0 - (aux_fval / aux_best)) > 0.001
                  aux_best = aux_fval;
               else
                  better = 0;
               end
            end
         end
         
         popold(pop_size, :) = gvec(index)';
         
      end

      pop = popold; % the old population becomes the current population
      
      % Evaluate the individuals of the first population
      fitness = zeros(pop_size, 1);
      for ind = 1:pop_size
         if refine_firsts % Refine first population with a 
                          % local search if needed
            qvec(index) = pop(ind,:)';
            q = cell2struct(num2cell(qvec, np), parnm);
            q.free = free;
            [q, ~, funct_val] = local_search('predict_pets', q, data, ..., 
                                             auxData, weights, filternm);
            q = rmfield(q, 'free');
            qvec = cell2mat(struct2cell(q));
            pop(ind,:) = qvec(index)';
            fitness(ind) = funct_val;
         else % Evaluate each individual if not refined
            qvec(index) = pop(ind,:)';
            q = cell2struct(num2cell(qvec, np), parnm);
            f_test = feval(filternm, q);
            % If the function evaluation does not pass the filter then 
            % try to reduce the maximum and minimums for the random parameter
            % values and try again till obtain a feasible individual. 
            if ~f_test 
               fprintf('The parameter set does not pass the filter. \n');
            end
            [f, f_test] = feval(func, q, data, auxData);
            if ~f_test 
               fprintf('The parameter set for the simplex construction is not realistic. \n');
            end
            [P, meanP] = struct2vector(f, nm);
            fitness(ind) = feval(fileLossfunc, Y, meanY, P, meanP, W);
         end
      end

      %% Initialize function evaluations and fitness values
      nfes = 0;
      bsf_fit_var = 1e+30;
      bsf_solution = zeros(1, problem_size);

      % Update evaluations and best fitness (value and parameters)
      for i = 1 : pop_size
         nfes = nfes + 1;

         if fitness(i) < bsf_fit_var
            bsf_fit_var = fitness(i);
            bsf_solution = pop(i, :);
         end
         % Check stopping criteria
         if max_calibration_time > 0
            current_time = toc(time_start)/60;
            if current_time > max_calibration_time; break; end
         else
            if nfes > max_nfes; break; end
         end
      end

      memory_sf = 0.5 .* ones(memory_size, 1);
      memory_cr = 0.5 .* ones(memory_size, 1);
      memory_pos = 1;

      %% Main loop
      while nfes < max_nfes
         fprintf('Num func evals %d \n', nfes);
         pop = popold; % the old population becomes the current population
         [temp_fit, sorted_index] = sort(fitness, 'ascend');

         if verbose
            % Print some fitness values
            fprintf('Best %d values found: ', verbose_options);
            if verbose_options <= pop_size
               disp(temp_fit(1:verbose_options).');
            else
               disp(temp_fit(1:pop_size).');
            end
         end

         mem_rand_index = ceil(memory_size * rand(pop_size, 1));
         mu_sf = memory_sf(mem_rand_index);
         mu_cr = memory_cr(mem_rand_index);

         %% Generating crossover rate
         cr = mu_cr + 0.1 .* rand(size(mu_cr,1),1);  % alternative with base Matlab
         term_pos = mu_cr == -1;
         cr(term_pos) = 0;
         cr = min(cr, 1);
         cr = max(cr, 0);

         %% Generating scaling factor
         sf = mu_sf + 0.1 * tan(pi * (rand(pop_size, 1) - 0.5));
         pos = find(sf <= 0);

         while ~isempty(pos)
            sf(pos) = mu_sf(pos) + 0.1 * tan(pi * (rand(length(pos), 1) - 0.5));
            pos = find(sf <= 0);
         end

         sf = min(sf, 1); 

         r0 = 1 : pop_size;
         popAll = [pop; archive.pop];
         [r1, r2] = gnR1R2(pop_size, size(popAll, 1), r0);

         pNP = max(round(p_best_rate * pop_size), 2); %% choose at least two best solutions
         randindex = ceil(rand(1, pop_size) .* pNP); %% select from [1, 2, 3, ..., pNP]
         randindex = max(1, randindex); %% to avoid the problem that rand = 0 and thus ceil(rand) = 0
         pbest = pop(sorted_index(randindex), :); %% randomly choose one of the top 100p% solutions

         vi = pop + sf(:, ones(1, problem_size)) .* (pbest - pop + pop(r1, :) - popAll(r2, :));
         vi = boundConstraint(vi, pop, ranges);
         mask = rand(pop_size, problem_size) > cr(:, ones(1, problem_size)); % mask is used to indicate which elements of ui comes from the parent
         rows = (1 : pop_size).'; cols = floor(rand(pop_size, 1) * problem_size)+1; % choose one position where the element of ui doesn't come from the parent
         jrand = sub2ind([pop_size problem_size], rows, cols); mask(jrand) = false;
         ui = vi; ui(mask) = pop(mask);

         children_fitness = zeros(size(ui,1), 1);
         %% Evaluate children
         for child = 1:size(ui,1)
            qvec(index) = ui(child,:)';
            q = cell2struct(num2cell(qvec, np), parnm);
            f_test = feval(filternm, q);
            non_feasible = 0;
            % If does not pass the filter then try to reduce the maximum and
            % minimums for the random parameter values and try again till obtain a
            % feasible individual. 
            if ~f_test
               % Fix individual by reducing its parameter values by 5%
               max_factor = 0.05;
               min_factor = 0.01;
               while ~f_test 
                  % Initializing warning counter and the maximum number of
                  % warnings allowed (to the number of parameters multiplied
                  % by 10 to try different parameter configurations)
                  warning_counter = 0;
                  max_warnings = length(index) * 10; 
                  auxvalue = (max_factor-min_factor) * rand(1) + min_factor; % The value to reduce/increase a parameter value
                  % Do it for each parameter till fix the individual
                  for param = 1:length(index) & ~f_test
                     auxpar = qvec(index(param));
                     if (rand(1) < .5) % Decrease
                        qvec(index(param)) = qvec(index(param)) * (1-auxvalue);
                     else % Increase
                        qvec(index(param)) = qvec(index(param)) / (1-auxvalue);
                     end
                     % Test if parameter configuration is feasible
                     q = cell2struct(num2cell(qvec, np), parnm);

                     % Try to catch an warning or error when evaluating DEB
                     % in order to properly fix the indivudual parameters 
                     try
                        f_test = feval(filternm, q);
                     catch
                        warning_counter = warning_counter + 1;
                        qvec(index(param)) = auxpar;
                        if warning_counter >= max_warnings
                           f_test = 1;
                           non_feasible = 1;
                        end
                     end

                     % If individual continues not being feasible then
                     % choose if return to the previous solution value or
                     % maintain the generated one
                     if ~f_test 
                        if (rand(1) < .5) 
                           qvec(index(param)) = auxpar;
                        end
                     end
                  end
                  % If minimum reduction/increase factor is achieved set
                  % configuration as non feasible. Later its fitness will be
                  % set to a maximum value to erase it. 
                  if (max_factor >= 0.98 && ~f_test && ~non_feasible)
                     non_feasible = 1;
                     f_test = 1;
                  else % decrease factor and keep trying
                     max_factor = min((max_factor + 0.01), 1);
                  end
               end
            end
            % If solution is feasible then evaluate it.  
            if ~non_feasible
               [f, f_test] = feval(func, q, data, auxData);
               if ~f_test % If DEB function is not feasible then set an extreme fitness value.
                  children_fitness(child) = pen_val;
               else % If not set the fitness
                  ui(child,:) = qvec(index)';
                  [P, meanP] = struct2vector(f, nm);
                  children_fitness(child) = feval(fileLossfunc, Y, meanY, P, meanP, W);
               end
            % If solution is not feasible then set an extreme fitness value.  
            else
              children_fitness(child) = pen_val;
            end
         end

         %% Update best fitness found so far
         for i = 1 : pop_size
            nfes = nfes + 1;
            % If individual is factible
            if children_fitness(i) ~= pen_val
               % Check if local search is active an if it is then check if to
               % apply to the current individual
               if refine_running && (nfes > ls_nfes)
                  if (rand(1) < refine_run_prob)
                     fprintf('Refining individual using local search \n');
                     refine = 1;
                     qvec(index) = ui(i,:)';
                     q = cell2struct(num2cell(qvec, np), parnm);
                     q.free = free;
                     [q, iters, funct_val] = local_search('predict_pets', q, data, auxData, weights, filternm);
                     q = rmfield(q, 'free');
                  else
                     refine = 0;
                  end
               else
                  refine = 0;
               end
               if refine
                  % The number of function evaluations are not considered thus
                  % it is necessary for the population resize procedure of the
                  % algorithm.
                  nfes = nfes + iters;
                  qvec = cell2mat(struct2cell(q));
                  ui(i,:) = qvec(index)';
                  children_fitness(i) = funct_val;
               end

               % Check if better than actual best
               if children_fitness(i) < bsf_fit_var
                  bsf_fit_var = children_fitness(i);
                  bsf_solution = ui(i, :);
               end
            end
            % Check if stopping criteria has been achieved
            if max_calibration_time > 0
               current_time = toc(time_start)/60;
               if current_time > max_calibration_time; break; end
            else
               if nfes > max_nfes; break; end
            end
         end

         %% Comparison between parents and children
         % Compare parents and children fitness. Then...
         dif = abs(fitness - children_fitness);
         % .. if I == 1: the parent is better; I == 2: the offspring is better
         I = (fitness > children_fitness);
         goodCR = cr(I == 1);  
         goodF = sf(I == 1);
         dif_val = dif(I == 1);

         % isempty(popold(I == 1, :))   
         archive = updateArchive(archive, popold(I == 1, :), fitness(I == 1));

         [fitness, I] = min([fitness, children_fitness], [], 2);

         popold = pop;
         popold(I == 2, :) = ui(I == 2, :);

         num_success_params = numel(goodCR);

         if num_success_params > 0 
            sum_dif = sum(dif_val);
            dif_val = dif_val / sum_dif;

            %% for updating the memory of scaling factor 
            memory_sf(memory_pos) = (dif_val' * (goodF .^ 2)) / (dif_val' * goodF);

            %% for updating the memory of crossover rate
            if max(goodCR) == 0 || memory_cr(memory_pos)  == -1
               memory_cr(memory_pos)  = -1;
            else
               memory_cr(memory_pos) = (dif_val' * (goodCR .^ 2)) / (dif_val' * goodCR);
            end

            memory_pos = memory_pos + 1;
            if memory_pos > memory_size;  memory_pos = 1; end
         end
         % Check if stopping criteria has been achieved
         if max_calibration_time > 0
            current_time = round(toc(run_time_start)/60);
            if current_time > max_calibration_time; break; end
            if verbose
               fprintf('Time accomplished: %d of %d minutes (%d %%) for the run  %d \n', ...,
                  current_time, max_calibration_time, ..., 
                  round((current_time/max_calibration_time)*100.0), run);
               if num_runs > 1
                   current_time = round(toc(time_start)/60);
                   fprintf('The time accomplished for the whole calibration: %d of %d minutes (%d %%) \n', ...,
                       current_time, max_calibration_time*num_runs, ..., 
                       round((current_time/(max_calibration_time*num_runs))*100.0));
               end
            end
         else
            if nfes > max_nfes; break; end
         end
      end
      
      if verbose
         % Print the best result values and finish
         fprintf('Best-so-far error value = %1.8e\n', bsf_fit_var);
         fprintf('Best-so-far configuration values: \n');
         disp(bsf_solution);
      end

      bsf_fval = bsf_fit_var;
      qvec(index) = bsf_solution';
      q = cell2struct(num2cell(qvec, np), parnm);
      q.free = free; % add substructure free to q 

      %% If best one wants to be refined with the Nelder Mead's simplex method
      if refine_best
         fprintf('Refining best individual found using local search \n');
         [q, ~, fval] = local_search('predict_pets', q, data, auxData, weights, filternm);
         while (1.0 - (fval / bsf_fval)) > 0.0000001
            if verbose
               % Print the best and finish
               fprintf('Improved from = %1.8e to %1.8e \n', bsf_fval, fval);
            end
            % Update the best fitness
            bsf_fval = fval;
            % Launch the local search again
            [q, ~, fval] = local_search('predict_pets', q, data, auxData, weights, filternm);
         end
      end
      % Update best solution set
      solution_set = updateArchive(solution_set, popold, fitness);
      
      %% Setting run information
      tEnd = datevec(toc(run_time_start)./(60*60*24));
      tEnd = tEnd(3:6);
      info.(strcat('run_', num2str(run))).run_time = tEnd;
      info.(strcat('run_', num2str(run))).fun_evals = nfes;
   end
   tEnd = datevec(toc(time_start)./(60*60*24));
   tEnd = tEnd(3:6);
   info.run_time = tEnd;
   %% Add best to solutions archive and finish
   if num_runs > 0 && refine_best
      aux = q; 
      aux = rmfield(aux, 'free');
      auxvec = cell2mat(struct2cell(aux));
      solution_set = updateArchive(solution_set, auxvec(index)', fval);
   end
end
