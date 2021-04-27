  function dVRE = dget_VRE(a, VRE, parsVRe, T_pars, t_T, f)
  % this functions calculate the changes in all the state variables when
  % food levels are changed, while considering a variable temperature
  % during the period under study. It allows shrinking of structure to
  % support maintenance, no loss of energy is given to this turnover!
  % a: scalar with time since start of starvation period.
  % VRe: 3-vector with starting values of V, Er and e.
  % dVRe: 3-vector with (dV/da, dR/da, de/da)
  % parsVRe: a vector containing the parameters: kap, kJ, g, Lm, LT,
  % Tref, TA, sM, UHp, pAm and v.
  % t_T: array Nx2 with T at time during the period for which dynamics are to be calculated 
  % f: scaled functional response during a.
  
  V = VRE(1); % cm, structural length
  R = VRE(2); % J, Reproductive buffer accumulated
  E = VRE(3); % J, Reserves at a = 1 --- e * E_m * L^3
 
  kap = parsVRe(1);   
  kJ = parsVRe(2);
  g = parsVRe(3);
  Lm = parsVRe(4);
  LT = parsVRe(5);
  T_ref = parsVRe(6);
  s_M = parsVRe(7);
  UHp = parsVRe(8);
  p_Am = parsVRe(9);
  v = parsVRe(10);
  E_G= parsVRe(11);
  
  t = t_T(1,:);
  T = t_T(2,:);
  T1=csapi(t,T,a);
  TC=tempcorr(T1, T_ref, T_pars);
  
  L = V.^(1/3);
  e = v * E / p_Am / V;
  
  pA = TC * p_Am * L .^ 2 * s_M * f;                                             % J, assimilation
  pC = TC * p_Am * L .^ 2 .* ((g + LT/ Lm) * s_M + L/ Lm)/ (1 + g/ e);     % J, mobilisation
  pS = TC * p_Am * kap * L.^2 .* (L + LT/Lm);                              % J, somatic  maint
  pJ = TC * p_Am * kJ * UHp;                                               % J, maturity  maint
  
 % generate dL/dt, dR/dt, de/dt
  
 if kap*pC>=pS   %kappa rule
     dV = (pC * kap - pS) / E_G;             % cm^3 of structure
     dR = ((1 - kap) * pC - pJ);             % J, maturation/reproduction
 else     % priority order maintenance > reproduction > growth
     dR = pC - pS - pJ;                        % J, maturation/reproduction
     dV = 0;                                 % cm^3 of structure
     if dR < 0      
         if R>0    % maintenance will be covered by the reproductive buffer
             if R>abs(dR)
                 dV = 0;                                 % cm^3 of structure
             else   % reproductive buffer is not enough, mobilisation of structure with 100% turnover??
                 dV = (R+dR)/E_G;             % the last bit of Er is used
                 dR = -R;                     % Er is emptied 
             end
         else
             dV = dR / E_G;                         % cm^3 of structure
             dR = 0;
         end
     end
 end
 dE = pA - pC;                              % J, change in energy reserves


  % pack dV/da, dR/da, de/da, 
  dVRE = [dV; dR; dE];