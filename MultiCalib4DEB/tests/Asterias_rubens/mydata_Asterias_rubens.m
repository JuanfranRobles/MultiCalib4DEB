%% mydata_Asterias_rubens
% Sets referenced data

%%
function [data, auxData, metaData, txtData, weights] = mydata_Asterias_rubens 
  % created by Starrlight Augustine, Bas Kooijman, Dina Lika, Goncalo Marques and Laure Pecquerie 2015/03/31
  % last modified: 2015/07/28 
  
  %% Syntax
  % [data, auxData, metaData, txtData, weights] = <../mydata_my_pet.m *mydata_my_pet*>
  
  %% Description
  % Sets data, pseudodata, metadata, auxdata, explanatory text, weights coefficients.
  % Meant to be a template in add-my-pet
  %
  % Output
  %
  % * data: structure with data
  % * auxData: structure with auxilliairy data that is required to compute predictions of data (e.g. temperature, food.). 
  %   auxData is unpacked in predict and the user needs to construct predictions accordingly.
  % * txtData: text vector for the presentation of results
  % * metaData: structure with info about this entry
  % * weights: structure with weights for each data set
  
  %% Remarks
  % Plots with the same labels and units can be combined into one plot by assigning a cell string with dataset names to metaData.grp.sets, and a caption to metaData.grp.comment. 
  
%% set metaData

metaData.phylum     = 'Echinodermata'; 
metaData.class      = 'Asteroidea'; 
metaData.order      = 'Forcipulatida'; 
metaData.family     = 'Asteriidae';
metaData.species    = 'Asterias_rubens'; % 
metaData.species_en = 'Common starfish'; 
metaData.T_typical  = C2K(20); % K, body temp
metaData.data_0     = {'ab'; 'ap'; 'am'; 'Lb'; 'Lp'; 'Li'; 'Wdb'; 'Wdp'; 'Wdi'; 'Ri'};  % tags for different types of zero-variate data
metaData.data_1     = {'t-L'; 'L-W'}; % tags for different types of uni-variate data

metaData.COMPLETE = 3.5; % using criteria of LikaKear2011

metaData.author   = {'Antonio Aguera'};            % put names as authors as separate strings:  {'FirstName1 LastName2','FirstName2 LastName2'} , with corresponding author in first place 
metaData.date_subm = [2018 06 11];                       % [year month day], date at which the entry is submitted
metaData.email    = {'aaga@aqua.dtu.dk'};              % e-mail of corresponding author
metaData.address  = {'Technical University of Denmark, National Institute of Aquatic Resources, ?roddevej 80, 7900 Nyk?bing Mors, Denmark'};   % affiliation, postcode, country of the corresponding author

% uncomment and fill in the following fields when the entry is updated:
% metaData.author_mod_1  = {'FirstName3 LastName3'};          % put names as authors as separate strings:  {'author1','author2'} , with corresponding author in first place 
% metaData.date_mod_1    = [2017 09 18];                      % [year month day], date modified entry is accepted into the collection
% metaData.email_mod_1   = {'myname@myuniv.univ'};            % e-mail of corresponding author
% metaData.address_mod_1 = {'affiliation, zipcode, country'}; % affiliation, postcode, country of the corresponding author

% for curators only ------------------------------
% metaData.curator     = {'FirstName LastName'};
% metaData.email_cur   = {'myname@myuniv.univ'}; 
% metaData.date_acc    = [2015 04 22]; 
%-------------------------------------------------

%% set data
%% section 1
% zero-variate data 

% age 0 is at onset of embryo development
data.ab = 3;      units.ab = 'd';    label.ab = 'age at birth';  bibkey.ab = 'Agueetal2018';   comment.ab  = 'mean value taken from several measurements'; 
  temp.ab = C2K(15);  units.temp.ab = 'K'; label.temp.ab = 'temperature';

data.aj = 32;      units.aj = 'd';    label.aj = 'age at start of metamorphosis';  bibkey.aj = 'Agueetal2018';   comment.aj  = 'mean value taken from several measurements'; 
  temp.aj = C2K(15);  units.temp.aj = 'K'; label.temp.aj = 'temperature';

 % observed age at birth is frequently larger than ab, because of diapauzes during incubation

% Please specify what type of length measurement is used for your species.
data.Lb  = 0.3;    units.Lb  = 'mm';   label.Lb  = 'early bip cord length';            bibkey.Lb  = 'Agueetal2018';  
data.Lj  = 3;      units.Lj  = 'mm';   label.Lj  = 'late brachiolaria cord length';    bibkey.Lb  = 'Agueetal2018'; 
data.Lp  = 3.5;      units.Lp  = 'cm';   label.Lp  = 'arm length';                       bibkey.Lp  = 'Agueetal2018';
data.Li  = 15;     units.Li  = 'cm';   label.Li  = 'ultimate arm length';              bibkey.Li  = 'Agueetal2018';

data.Wd0 = 1;   units.Wd0 = 'ug';    label.Wd0 = 'dry weight of the egg';            bibkey.Wd0 = 'Agueetal2018';
%data.Wdb = 5.8e-5; units.Wdb = 'g';    label.Wdb = 'dry weight at birth';              bibkey.Wdb = 'Agueetal2018';
data.Wwp = 7;      units.Wwp = 'g';    label.Wwp = 'wet weight at puberty';            bibkey.Wwp = 'Agueetal2018';
data.Wwi = 450;    units.Wwi = 'g';    label.Wwi = 'ultimate wet weight';              bibkey.Wwi = 'Agueetal2018';

data.GSI  = 0.30;       units.GSI  = '-';       label.GSI  = 'gonado somatic index';   bibkey.GSI = 'Oudetal1979';   
  temp.GSI = C2K(9); units.temp.GSI = 'K';   label.temp.GSI = 'temperature';

data.PI  = 0.16;        units.PI  = '-';        label.PI  = 'pyloric index';           bibkey.PI = 'Agueetal2018';
% end of cell 1
%% uni-variate data
data.LW = [ 4.63	4.48	4.34	4.35	4.37	3.79	4.90	4.65	3.41	3.98	3.79	3.64	4.14	4.30	4.17	3.88	4.35	4.77	5.22	5.56	5.41	5.78	5.52	4.93	6.58	5.36	4.47	5.03	6.08	5.54	4.76	6.47	5.78	5.31	6.52	4.42   0.728	0.848	0.912	1.029	1.102	1.268	1.422	1.542	1.569	1.43	1.517	1.61	1.682	1.889	1.913	2.129	2.365	2.287   6.75	7	7.5	8.25	7.75	9	5.25	7.25	6.5	9.5	5.25	8	6.75	6.75	6	9	9.25	10.25	8.25	10.5	10	9.75	8.5	9	6.5	5.75	4.75	8	5.5	12.5	6.25	6.25	6.75	5.5	7.5	5.5	5.75	6	6	5.25	6.5	6.5	5.75	6	7	5.75	5.75	6	9.5	9.25	9.25	9.5	10.25	6	10	9.5	10.5	9.75	8	8.5	5	7.5	5.75	4	3.5;      % cm, arm length at f
            20.00	15.00	20.00	15.00	14.00	10.00	20.00	15.00	9.00	14.00	14.00	10.00	17.00	15.00	17.00	10.00	11.00	18.00	30.25	39.60	26.07	35.34	44.16	22.50	42.40	19.55	21.50	28.25	30.66	35.35	32.29	40.84	43.66	31.11	23.67	21.40   0.0893	0.1444	0.2178	0.3276	0.2159	0.4671	0.7499	0.7689	0.5634	0.5714	0.6491	1.067	1.2793	2.4043	1.5869	1.7621	2.6493	1.8919  68.92	51.69	86.15	60.30	67.20	63.75	18.95	70.99	46.86	95.45	31.01	88.90	50.31	48.24	36.18	140.59	150.24	186.08	127.84	155.41	192.97	168.16	140.94	120.95	62.37	37.90	29.63	87.87	49.97	184.70	67.20	45.14	65.13	52.03	69.26	47.55	54.45	46.18	61.68	41.70	57.20	74.09	38.59	49.97	77.53	42.04	57.89	51.69	109.92	106.82	133.01	166.09	177.81	30.32	123.71	134.73	176.43	120.61	66.85	97.17	40.32	91.66	59.61	17.92	12.06]';   % g, wet weights at f and T
units.LW = {'cm', 'g'};     label.LW = {'arm length', 'wet weights'};  bibkey.LW = 'Agueetal2018';
temp.LW    = C2K(10);  units.temp.LW = 'K'; label.temp.LW = 'temperature';
comment.LW = 'All data from well fed individuals, no Er in weight';

    % Respirometry

data.L_JO = [... arm length, oxygen consumption
1.10	1.82
1.19	2.94
1.20	2.51
1.30	1.70
1.40	4.23
1.45	1.76
1.68	3.63
1.70	6.09
1.76	5.25
1.84	2.89
1.93	5.39
2.15	6.16
2.23	8.21
2.82	12.41
];
units.L_JO= {'cm','mgO2/d'}; label.L_JO = {'Arm length', 'oxygen consumption'}; bibkey.L_JO='Agueetal2018';
temp.L_JO = C2K(18); comment.L_JO = 'Feeding animals - f for assimilation = 0.8'; 

data.L_JO_f0 = [... arm length, oxygen consumption
1.674	1.155793114
1.681	1.576687755
1.685	0.89224571
1.757	1.285429758
1.80	1.888541802
1.831	1.45430449
1.874	0.8745977
1.92	1.787069786
1.95	2.507567564
2.00	3.012482366
2.516	3.729213847
2.657	4.726374139
];
units.L_JO_f0= {'cm','mgO2/d'}; label.L_JO_f0 = {'Arm length', 'oxygen consumption'}; bibkey.L_JO_f0='Agueetal2018';
temp.L_JO_f0 = C2K(18); comment.L_JO_f0 = 'starving long enough (monitored) for f from digestion/assimilation = 0, rest f=f_fonds'; 

   
    %% growth during the spring experiment
data.t_Ww_N16 = [ % wet weight at time during the spring experimet
1	07.7778
8	12.5556
15	14.0000
22	16.6667
29	20.7778
37	23.6667
43	27.2222
50	34.0000
];  
units.t_Ww_N16   = {'d', 'g'};  label.t_Ww_N16 = {'time', 'wet weight'};  bibkey.t_Ww_N16 = 'Agueetal2018';
temp.t_Ww_N16    = C2K(17.5);  units.temp.t_Ww_N16 = 'K'; label.temp.t_Ww_N16 = 'temperature';
comment.t_Ww_N16 = 'from experimental data, fed at N=16, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N16 = [ % length at time during the spring experiment
1	3.5000
8	3.3750
15	3.7222
22	4.0139
29	4.3611
37	4.5833
43	4.9167
50	5.0556
];  
units.t_Lw_N16   = {'d', 'cm'};  label.t_Lw_N16 = {'time', 'arm length'};  bibkey.t_Lw_N16 = 'Agueetal2018';
temp.t_Lw_N16    = C2K(17.5);  units.temp.t_Lw_N16 = 'K'; label.temp.t_Lw_N16 = 'temperature';
comment.t_Lw_N16 = 'from experimental data, fed at N=16, temperature is only average, to use daily temperature in predict';    

data.t_JX_N16 = [ % feeding rate at time during the spring experiment
10	0.0363
11	0.0519
12	0.0415
13	0.0571
14	0.0363
15	0.0605
16	0.0151
17	0.0454
18	0.0504
19	0.0202
20	0.0605
21	0.0655
22	0.0524
23	0.0143
24	0.0571
25	0.0619
26	0.0809
27	0.1000
28	0.0286
29	0.0966
30	0.0460
31	0.0322
32	0.0920
33	0.0644
34	0.0736
35	0.0782
36	0.1008
37	0.1245
38	0.0771
39	0.1245
40	0.1482
41	0.1423
42	0.1541
43	0.1164
44	0.0980
45	0.0980
46	0.0857
47	0.1164
48	0.1531
49	0.1164
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N16   = {'d', 'AFDW g'};  label.t_JX_N16 = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N16 = 'Agueetal2018';
temp.t_JX_N16    = C2K(17.5);  units.temp.t_JX_N16 = 'K'; label.temp.t_JX_N16 = 'temperature';
comment.t_JX_N16 = 'from experimental data, fed at N=16 = 12.8817gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N08 = [ % wet weight at time during the spring experimet
1	8.0000
8	11.4444
15	14.0000
22	16.6667
29	21.2222
37	23.4444
43	27.5556
50	32.0000
];  
units.t_Ww_N08   = {'d', 'g'};  label.t_Ww_N08 = {'time', 'wet weight'};  bibkey.t_Ww_N08 = 'Agueetal2018';
temp.t_Ww_N08    = C2K(17.5);  units.temp.t_Ww_N08 = 'K'; label.temp.t_Ww_N08 = 'temperature';
comment.t_Ww_N08 = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N08 = [ % length at time during the spring experiment
1	3.5000
8	3.5694
15	3.8194
22	4.2639
29	4.4167
37	4.6528
43	5.0556
50	5.2222
];  
units.t_Lw_N08   = {'d', 'cm'};  label.t_Lw_N08 = {'time', 'arm length'};  bibkey.t_Lw_N08 = 'Agueetal2018';
temp.t_Lw_N08    = C2K(17.5);  units.temp.t_Lw_N08 = 'K'; label.temp.t_Lw_N08 = 'temperature';
comment.t_Lw_N08 = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_JX_N08 = [ % feeding rate at time during the spring experiment
10	0.0363
11	0.0467
12	0.0415
13	0.0519
14	0.0415
15	0.0504
16	0.0101
17	0.0554
18	0.0504
19	0.0454
20	0.0554
21	0.0454
22	0.0428
23	0.0238
24	0.0571
25	0.0619
26	0.0809
27	0.0667
28	0.0476
29	0.0736
30	0.0460
31	0.0552
32	0.0828
33	0.0644
34	0.0874
35	0.0460
36	0.1067
37	0.1186
38	0.0889
39	0.0771
40	0.1126
41	0.1541
42	0.1423
43	0.1409
44	0.0796
45	0.0857
46	0.0919
47	0.1164
48	0.1102
49	0.1164
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N08   = {'d', 'AFDW g'};  label.t_JX_N08 = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N08 = 'Agueetal2018';
temp.t_JX_N08    = C2K(17.5);  units.temp.t_JX_N08 = 'K'; label.temp.t_JX_N08 = 'temperature';
comment.t_JX_N08 = 'from experimental data, fed at N=8 = 6.4406gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N04 = [ % wet weight at time during the spring experimet
1	8.0000
8	10.3333
15	11.6667
22	14.4444
29	19.1111
37	19.3333
43	24.3333
50	29.5556
];  
units.t_Ww_N04   = {'d', 'g'};  label.t_Ww_N04 = {'time', 'wet weight'};  bibkey.t_Ww_N04 = 'Agueetal2018';
temp.t_Ww_N04    = C2K(17.5);  units.temp.t_Ww_N04 = 'K'; label.temp.t_Ww_N04 = 'temperature';
comment.t_Ww_N04 = 'from experimental data, fed at N=4, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N04 = [ % length at time during the spring experiment
1	3.4722
8	3.5417
15	3.6250
22	3.9444
29	4.1944
37	4.3194
43	4.6389
50	4.7500
];  
units.t_Lw_N04   = {'d', 'cm'};  label.t_Lw_N04 = {'time', 'arm length'};  bibkey.t_Lw_N04 = 'Agueetal2018';
temp.t_Lw_N04    = C2K(17.5);  units.temp.t_Lw_N04 = 'K'; label.temp.t_Lw_N04 = 'temperature';
comment.t_Lw_N04 = 'from experimental data, fed at N=4, temperature is only average, to use daily temperature in predict';    

data.t_JX_N04 = [ % feeding rate at time during the spring experiment
10	0.0311
11	0.0415
12	0.0259
13	0.0726
14	0.0311
15	0.0403
16	0.0353
17	0.0403
18	0.0403
19	0.0353
20	0.0605
21	0.0454
22	0.0571
23	0.0238
24	0.0476
25	0.0524
26	0.0809
27	0.1047
28	0.0619
29	0.0690
30	0.0414
31	0.0598
32	0.0782
33	0.0690
34	0.0920
35	0.0690
36	0.0771
37	0.1126
38	0.1008
39	0.0593
40	0.1126
41	0.1245
42	0.1186
43	0.1470
44	0.0674
45	0.0919
46	0.0612
47	0.0919
48	0.1164
49	0.1225
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N04   = {'d', 'AFDW g'};  label.t_JX_N04 = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N04 = 'Agueetal2018';
temp.t_JX_N04    = C2K(17.5);  units.temp.t_JX_N04 = 'K'; label.temp.t_JX_N04 = 'temperature';
comment.t_JX_N04 = 'from experimental data, fed at N=4 = 3.2198gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N02 = [ % wet weight at time during the spring experimet
1	7.5556
8	11.0000
15	13.3333
22	16.4444
29	17.8889
37	21.0000
43	24.1111
50	30.1111
];  
units.t_Ww_N02   = {'d', 'g'};  label.t_Ww_N02 = {'time', 'wet weight'};  bibkey.t_Ww_N02 = 'Agueetal2018';
temp.t_Ww_N02    = C2K(17.5);  units.temp.t_Ww_N02 = 'K'; label.temp.t_Ww_N02 = 'temperature';
comment.t_Ww_N02 = 'from experimental data, fed at N=2, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N02 = [ % length at time during the spring experiment
1	3.3889
8	3.4861
15	3.6667
22	4.0556
29	4.3194
37	4.5278
43	4.6667
50	4.9167
];  
units.t_Lw_N02   = {'d', 'cm'};  label.t_Lw_N02 = {'time', 'arm length'};  bibkey.t_Lw_N02 = 'Agueetal2018';
temp.t_Lw_N02    = C2K(17.5);  units.temp.t_Lw_N02 = 'K'; label.temp.t_Lw_N02 = 'temperature';
comment.t_Lw_N02 = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_JX_N02 = [ % feeding rate at time during the spring experiment
10	0.0519
11	0.0311
12	0.0363
13	0.0622
14	0.0622
15	0.0454
16	0.0454
17	0.0554
18	0.0655
19	0.0454
20	0.0655
21	0.0504
22	0.0667
23	0.0286
24	0.0333
25	0.0714
26	0.0667
27	0.0762
28	0.0667
29	0.0552
30	0.0368
31	0.0506
32	0.0598
33	0.0598
34	0.0782
35	0.0736
36	0.0889
37	0.0711
38	0.0771
39	0.0771
40	0.0830
41	0.1008
42	0.1067
43	0.1041
44	0.0980
45	0.1102
46	0.1041
47	0.0796
48	0.1102
49	0.0980
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N02   = {'d', 'AFDW g'};  label.t_JX_N02 = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N02 = 'Agueetal2018';
temp.t_JX_N02    = C2K(17.5);  units.temp.t_JX_N02 = 'K'; label.temp.t_JX_N02 = 'temperature';
comment.t_JX_N02 = 'from experimental data, fed at N=8 = 6.4406gAFDW/m2, temperature is only average, to use daily temperature in predict';    

    %% growth during the Autumn experiment
data.t_Ww_N16_A = [ % wet weight at time during the autumn experimet
1	7.6667
7	10.8889
14	11.1111
22	13.8889
28	15.0000
35	15.5556
42	16.2222
];  
units.t_Ww_N16_A   = {'d', 'g'};  label.t_Ww_N16_A = {'time', 'wet weight'};  bibkey.t_Ww_N16_A = 'Agueetal2018';
temp.t_Ww_N16_A    = C2K(17.5);  units.temp.t_Ww_N16_A = 'K'; label.temp.t_Ww_N16_A = 'temperature';
comment.t_Ww_N16_A = 'from experimental data, fed at N=16, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N16_A = [ % length at time during the spring experiment
1	3.4167
7	3.3333
14	3.5000
22	3.7500
28	3.7917
35	3.8750
42	3.9306
];  
units.t_Lw_N16_A   = {'d', 'cm'};  label.t_Lw_N16_A = {'time', 'arm length'};  bibkey.t_Lw_N16_A = 'Agueetal2018';
temp.t_Lw_N16_A    = C2K(17.5);  units.temp.t_Lw_N16_A = 'K'; label.temp.t_Lw_N16_A = 'temperature';
comment.t_Lw_N16_A = 'from experimental data, fed at N=16, temperature is only average, to use daily temperature in predict';    

data.t_JX_N16_A = [ % feeding rate at time during the spring experiment
10	0.0266
11	0.0303
12	0.0341
13	0.0341
14	0.0303
15	0.0173
16	0.0260
17	0.0303
18	0.0390
19	0.0347
20	0.0433
21	0.0347
22	0.0233
23	0.0388
24	0.0349
25	0.0271
26	0.0155
27	0.0543
28	0.0543
29	0.0346
30	0.0433
31	0.0476
32	0.0519
33	0.0346
34	0.0433
35	0.0649
36	0.0199
37	0.0437
38	0.0318
39	0.0318
40	0.0397

];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N16_A   = {'d', 'AFDW g'};  label.t_JX_N16_A = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N16_A = 'Agueetal2018';
temp.t_JX_N16_A    = C2K(17.5);  units.temp.t_JX_N16_A = 'K'; label.temp.t_JX_N16_A = 'temperature';
comment.t_JX_N16_A = 'from experimental data, fed at N=16 = 12.8817gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N08_A = [ % wet weight at time during the spring experimet
1	7.6667
7	10.6667
14	11.5556
22	12.8889
28	13.1111
35	13.6667
42	14.3333

];  
units.t_Ww_N08_A   = {'d', 'g'};  label.t_Ww_N08_A = {'time', 'wet weight'};  bibkey.t_Ww_N08_A = 'Agueetal2018';
temp.t_Ww_N08_A    = C2K(17.5);  units.temp.t_Ww_N08_A = 'K'; label.temp.t_Ww_N08_A = 'temperature';
comment.t_Ww_N08_A = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N08_A = [ % length at time during the spring experiment
1	3.4444
7	3.3611
14	3.5000
22	3.7778
28	3.7083
35	3.8194
42	3.7778
];  
units.t_Lw_N08_A   = {'d', 'cm'};  label.t_Lw_N08_A = {'time', 'arm length'};  bibkey.t_Lw_N08_A = 'Agueetal2018';
temp.t_Lw_N08_A    = C2K(17.5);  units.temp.t_Lw_N08_A = 'K'; label.temp.t_Lw_N08_A = 'temperature';
comment.t_Lw_N08_A = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_JX_N08_A = [ % feeding rate at time during the spring experiment
10	0.0303
11	0.0228
12	0.0341
13	0.0190
14	0.0493
15	0.0260
16	0.0260
17	0.0217
18	0.0260
19	0.0217
20	0.0477
21	0.0173
22	0.0271
23	0.0194
24	0.0310
25	0.0194
26	0.0233
27	0.0465
28	0.0349
29	0.0216
30	0.0173
31	0.0303
32	0.0433
33	0.0346
34	0.0346
35	0.0519
36	0.0000
37	0.0199
38	0.0437
39	0.0437
40	0.0318
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N08_A   = {'d', 'AFDW g'};  label.t_JX_N08_A = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N08_A = 'Agueetal2018';
temp.t_JX_N08_A    = C2K(17.5);  units.temp.t_JX_N08_A = 'K'; label.temp.t_JX_N08_A = 'temperature';
comment.t_JX_N08_A = 'from experimental data, fed at N=8 = 6.4406gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N04_A = [ % wet weight at time during the spring experimet
1	7.3333
7	10.6667
14	11.2222
22	13.0000
28	13.3333
35	14.1111
42	14.5556
];  
units.t_Ww_N04_A   = {'d', 'g'};  label.t_Ww_N04_A = {'time', 'wet weight'};  bibkey.t_Ww_N04_A = 'Agueetal2018';
temp.t_Ww_N04_A    = C2K(17.5);  units.temp.t_Ww_N04_A = 'K'; label.temp.t_Ww_N04_A = 'temperature';
comment.t_Ww_N04_A = 'from experimental data, fed at N=4, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N04_A = [ % length at time during the spring experiment
1	3.4167
7	3.4722
14	3.5417
22	3.7500
28	3.6667
35	3.8472
42	3.8056
];  
units.t_Lw_N04_A   = {'d', 'cm'};  label.t_Lw_N04_A = {'time', 'arm length'};  bibkey.t_Lw_N04_A = 'Agueetal2018';
temp.t_Lw_N04_A    = C2K(17.5);  units.temp.t_Lw_N04_A = 'K'; label.temp.t_Lw_N04_A = 'temperature';
comment.t_Lw_N04_A = 'from experimental data, fed at N=4, temperature is only average, to use daily temperature in predict';    

data.t_JX_N04_A = [ % feeding rate at time during the spring experiment
10	0.0190
11	0.0266
12	0.0417
13	0.0266
14	0.0266
15	0.0303
16	0.0173
17	0.0390
18	0.0217
19	0.0347
20	0.0477
21	0.0217
22	0.0194
23	0.0233
24	0.0310
25	0.0271
26	0.0194
27	0.0388
28	0.0271
29	0.0303
30	0.0173
31	0.0433
32	0.0346
33	0.0562
34	0.0346
35	0.0346
36	0.0079
37	0.0159
38	0.0238
39	0.0199
40	0.0278
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N04_A   = {'d', 'AFDW g'};  label.t_JX_N04_A = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N04_A = 'Agueetal2018';
temp.t_JX_N04_A   = C2K(17.5);  units.temp.t_JX_N04_A = 'K'; label.temp.t_JX_N04_A = 'temperature';
comment.t_JX_N04_A = 'from experimental data, fed at N=4 = 3.2198gAFDW/m2, temperature is only average, to use daily temperature in predict';    

data.t_Ww_N02_A = [ % wet weight at time during the spring experimet
1	7.6667
7	9.4444
14	11.1111
22	13.1111
28	13.4444
35	14.5556
42	14.1111
];  
units.t_Ww_N02_A   = {'d', 'g'};  label.t_Ww_N02_A = {'time', 'wet weight'};  bibkey.t_Ww_N02_A = 'Agueetal2018';
temp.t_Ww_N02_A    = C2K(17.5);  units.temp.t_Ww_N02_A = 'K'; label.temp.t_Ww_N02_A = 'temperature';
comment.t_Ww_N02_A = 'from experimental data, fed at N=2, temperature is only average, to use daily temperature in predict';    

data.t_Lw_N02_A = [ % length at time during the spring experiment
1	3.3333
7	3.3889
14	3.5278
22	3.6528
28	3.6528
35	3.7361
42	3.7500
];  
units.t_Lw_N02_A   = {'d', 'cm'};  label.t_Lw_N02_A = {'time', 'arm length'};  bibkey.t_Lw_N02_A = 'Agueetal2018';
temp.t_Lw_N02_A    = C2K(17.5);  units.temp.t_Lw_N02_A = 'K'; label.temp.t_Lw_N02_A = 'temperature';
comment.t_Lw_N02_A = 'from experimental data, fed at N=8, temperature is only average, to use daily temperature in predict';    

data.t_JX_N02_A = [ % feeding rate at time during the spring experiment
10	0.0341
11	0.0266
12	0.0379
13	0.0379
14	0.0379
15	0.0390
16	0.0303
17	0.0433
18	0.0433
19	0.0173
20	0.0347
21	0.0173
22	0.0465
23	0.0271
24	0.0310
25	0.0194
26	0.0271
27	0.0388
28	0.0388
29	0.0346
30	0.0260
31	0.0303
32	0.0476
33	0.0389
34	0.0433
35	0.0389
36	0.0159
37	0.0476
38	0.0397
39	0.0318
40	0.0238
];  % d, starvation time and g, wet weight at time at f=0 and T
units.t_JX_N02_A   = {'d', 'AFDW g'};  label.t_JX_N02_A = {'time', 'mussel AFDW consumed'};  bibkey.t_JX_N02_A = 'Agueetal2018';
temp.t_JX_N02_A    = C2K(17.5);  units.temp.t_JX_N02_A = 'K'; label.temp.t_JX_N02_A = 'temperature';
comment.t_JX_N02_A = 'from experimental data, fed at N=8 = 6.4406gAFDW/m2, temperature is only average, to use daily temperature in predict';    


%% Starvation
 % changes of weight during starvation in spring
% data.t_Ww_f0 = [
% 1	8.222222222
% 8	8.111111111
% 15	7.444444444
% 22	7
% 29	7.111111111
% 37	6.222222222
% 43	5.888888889
% 50	5.888888889
% ];  % d, starvation time and g, wet weight at time at f=0 and T
% units.t_Ww_f0   = {'d', 'g'};  label.t_Ww_f0 = {'time', 'wet weight'};  bibkey.t_Ww_f0 = 'Agueetal2018';
% temp.t_Ww_f0    = C2K(17.5);  units.temp.t_Ww_f0 = 'K'; label.temp.t_Ww_f0 = 'temperature';
% comment.t_Ww_f0 = 'from experimental data, starved f=0, temperature is only average, to use daily temperature in predict';    
% 
% 
    % Larval development
data.t_Le = [4	4	4	4	4	5	5	5	5	5	7	7	7	7	7	9	9	9	9	9	12	12	12	12	15	15	15	19	19	19	19	19	26	26  32  32  32; % time fertilization(d), length (mm)
             0.4	0.35	0.33	0.36	0.32	0.4	0.41	0.42	0.38	0.43	0.51	0.47	0.46	0.45	0.46	0.57	0.48	0.54	0.49	0.49	0.61	0.6	0.61	0.58	0.74	0.73	0.71	0.82	0.87	0.91	0.87	0.89	1.74	1.44    2.5     2.8     3]'; 
units.t_Le= {'d','mm'}; label.t_Le = {'time since fertilization', 'width of bippinaria larvae'}; 
temp.t_Le = C2K(15); units.temp.t_Le = 'K'; label.temp.t_Le = 'temperature'; 
bibkey.t_Le= 'Agueetal2018';
comment.t_Le = 'larvae were fed every 2-3 days';



%% set weights for all real data
weights = setweights(data, []);

%% overwriting weights (remove these remarks after editing the file)
% the weights were set automatically with the function setweigths,
% if one wants to ovewrite one of the weights it should always present an explanation example:
%
% zero-variate data:
% weights.Wdi = 100 * weights.Wdi; % Much more confidence in the ultimate dry
%                                % weights than the other data points
% uni-variate data: 
% weights.tL = 2 * weights.tL;

%% set pseudodata and respective weights
% (pseudo data are in data.psd and weights are in weights.psd)
[data, units, label, weights] = addpseudodata(data, units, label, weights);

%% overwriting pseudodata and respective weights (remove these remarks after editing the file)
% the pseudodata and respective weights were set automatically with the function setpseudodata
% if one wants to overwrite one of the values then please provide an explanation
% example:
% data.psd.p_M = 1000;                    % my_pet belongs to a group with high somatic maint 
% weights.psd.kap = 10 * weights.psd.kap;   % I need to give this pseudo data a higher weights

%% pack auxData and txtData for output
auxData.temp = temp;
txtData.units = units;
txtData.label = label;
txtData.bibkey = bibkey;
if exist('comment','var')
  txtData.comment = comment;
end

%% Group plots
% set1 = {'L_dL','L_dL_a'}; comment1 = {'Spring (17.5C) - Autumn (9.5C)'};
% set2 = {'Ww_dWw','Ww_dWw_a'}; comment2 = {'Spring (17.5C) - Autumn (9.5C)'};
% set3 = {'L_JX','L_JX_a'}; comment3 = {'Spring (17.5C) - Autumn (9.5C)'};
% set4 = {'X_JX','X_JX_a'}; comment4 = {'Spring (17.5C) - Autumn (9.5C)'};
set1 = {'t_Ww_N16','t_Ww_N08','t_Ww_N04','t_Ww_N02'}; comment1 = {'Wet weight at time, Spring experiment'};
set2 = {'t_Lw_N16','t_Lw_N08','t_Lw_N04','t_Lw_N02'}; comment2 = {'Arm length at time, Spring experiment'};
set3 = {'t_JX_N16','t_JX_N08','t_JX_N04','t_JX_N02'}; comment3 = {'Feeding rate at time, Spring experiment'};
set4 = {'t_Ww_N16_A','t_Ww_N08_A','t_Ww_N04_A','t_Ww_N02_A'}; comment4 = {'Wet weight at time, Autumn experiment'};
set5 = {'t_Lw_N16_A','t_Lw_N08_A','t_Lw_N04_A','t_Lw_N02_A'}; comment5 = {'Arm length at time, Autumn experiment'};
set6 = {'t_JX_N16_A','t_JX_N08_A','t_JX_N04_A','t_JX_N02_A'}; comment6 = {'Feeding rate at time, Autumn experiment'};
set7 = {'t_GW','t_PW'}; comment7 = {'Gonad weight - Pyloric Weight'};
% set6 = {'L_JO','L_JO_f0'}; comment6 = {'Feeding - Starved'};
metaData.grp.sets = {set1,set2,set3,set4,set5,set6,set7};
metaData.grp.comment = {comment1,comment2,comment3,comment4,comment5,comment6,comment7};


%% Discussion points
D1 = 'Author_mod_1: I found information on the number of eggs per female as a function of length in Anon2013 that was much higher than in Anon2015 but chose to not include it as the temperature was not provided';
% optional bibkey: metaData.bibkey.D1 = 'Anon2013';
D2 = 'Author_mod_1: I was surprised to observe that the weights coefficient for ab changed so much the parameter values';     
% optional bibkey: metaData.bibkey.D2 = 'Kooy2010';
metaData.discussion = struct('D1', D1, 'D2', D2);

%% Facts
% list facts: F1, F2, etc.
% make sure each fact has a corresponding bib key
% do not put any DEB modelling assumptions here, only relevant information on
% biology and life-cycles etc.
F1 = 'The larval stage lasts 202 days and no feeding occurs';
metaData.bibkey.F1 = 'Wiki'; % optional bibkey
metaData.facts = struct('F1',F1);

%% References
% the following reference should be kept for chemical parameter settings -----------------------------
bibkey = 'Kooy2010'; type = 'Book'; bib = [ ...  % used in setting of chemical parameters and pseudodata
'author = {Kooijman, S.A.L.M.}, ' ...
'year = {2010}, ' ...
'title  = {Dynamic Energy Budget theory for metabolic organisation}, ' ...
'publisher = {Cambridge Univ. Press, Cambridge}, ' ...
'pages = {Table 4.2 (page 150), 8.1 (page 300)}, ' ...
'howpublished = {\url{http://www.bio.vu.nl/thb/research/bib/Kooy2010.html}}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
%------------------------------------------------------------------------------------------------------

 % References for the data, following BibTex rules
 % author names : author = {Last Name, F. and Last Name2, F2. and Last Name 3, F3. and Last Name 4, F4.}
 % latin names in title e.g. \emph{Pleurobrachia pileus}

bibkey = 'Wiki'; type = 'Misc'; bib = [...
'howpublished = {\url{http://en.wikipedia.org/wiki/my_pet}},'...% replace my_pet by latin species name
'note = {Accessed : 2015-04-30}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
%
bibkey = 'MollCano2010'; type = 'Article'; bib = [ ... % meant as example; replace this and further bib entries
'author = {M{\o}ller, L. F. and Canon, J. M. and Tiselius, P.}, ' ... 
'year = {2010}, ' ...
'title = {Bioenergetics and growth in the ctenophore \emph{Pleurobrachia pileus}}, ' ...
'journal = {Hydrobiologia}, ' ...
'volume = {645}, ' ...
'number = {4}, '...
'pages = {167-178}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
%
bibkey = 'Anon2015'; type = 'Misc'; bib = [ ...
'author = {Anonymous}, ' ...
'year = {2015}, ' ...
'howpublished = {\url{http://www.fishbase.org/summary/Rhincodon-typus.html}}'];
metaData.biblist.(bibkey) = ['''@', type, '{', bibkey, ', ' bib, '}'';'];
