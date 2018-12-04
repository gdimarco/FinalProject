%% Import data file
[~,~,stressData] = xlsread('/Users/giulianadimarco/Documents/Texas Tech/Research/Data/R15StressData.xlsx','R15StressData');
varNames = cellfun(@(x) x(isstrprop(x,'alphanum')),stressData(1,:),'UniformOutput',false); %removes spaces & illegal characters from variable names
%% create table and add new cols
stressDataTable = cell2table(stressData(2:end,:),'VariableNames',varNames);
stressDataTable.PropCorrect = ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH)) ./ (stressDataTable.NUMTRIALS);
stressDataTable.PropPrem = (stressDataTable.NUMPREMATURE)./(stressDataTable.NUMTRIALS);
stressDataTable.PropOmit = (stressDataTable.NUMOMISSIONS) ./ (stressDataTable.NUMTRIALS);
stressDataTable.RatioPersCorrect = (stressDataTable.TOTALPOSTRNFRSPS) ./ ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH));
stressDataTable.RatioPersPrem = (stressDataTable.TOTALPOSTPREMATURERSPS) ./ (stressDataTable.NUMPREMATURE);
stressDataTable.RatioPersOmit = (stressDataTable.TOTALPOSTOMISSIONTORSPS) ./ (stressDataTable.NUMOMISSIONS);
%% get mean proportions separated by group,genotype, and session type
stressDataArray = grpstats(stressDataTable,{'GROUP','Genotype','SessionType'},{'mean','std'},'DataVars',{'PropCorrect','PropPrem','PropOmit','RatioPersCorrect','RatioPersPrem','RatioPersOmit'});
%% run statistics
% ranovatbl = ranova(rm); % repeated measures ANOVA
% c = multcompare(stats,Name,Value); % post-hoc test
%% create graphs
categories = categorical({'Non-Tg Continuous', 'Tg Continuous','Non-Tg Intermittent','Tg Intermittent'});

figure(1);
hold on
ylim([0 1.0]);
subplot(3,2,1);
bar(categories,[stressDataArray{1:6,5}, stressDataArray{7:12,5}, stressDataArray{13:18,5}, stressDataArray{19:24,5}]'); 
title('Proportion Correct');
subplot(3,2,2);
bar(categories,[stressDataArray{1:6,11}, stressDataArray{7:12,11}, stressDataArray{13:18,11}, stressDataArray{19:24,11}]');
title('Perservarative Correct');
subplot(3,2,3);
bar(categories,[stressDataArray{1:6,7}, stressDataArray{7:12,7}, stressDataArray{13:18,7}, stressDataArray{19:24,7}]');
title('Proportion Premature');
subplot(3,2,4);
bar(categories,[stressDataArray{1:6,13}, stressDataArray{7:12,13}, stressDataArray{13:18,13}, stressDataArray{19:24,13}]');
title('Perservarative Premature');
subplot(3,2,5);
bar(categories,[stressDataArray{1:6,9}, stressDataArray{7:12,9}, stressDataArray{13:18,9}, stressDataArray{19:24,9}]');
title('Proportion Omitted');
subplot(3,2,6);
bar(categories,[stressDataArray{1:6,15}, stressDataArray{7:12,15}, stressDataArray{13:18,15}, stressDataArray{19:24,15}]');
title('Perservarative Omitted');