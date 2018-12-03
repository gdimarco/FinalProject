%% Import data file
[~,~,stressData] = xlsread('/Users/giulianadimarco/Documents/Texas Tech/Research/Data/R15StressData.xlsx','R15StressData');
varNames = cellfun(@(x) x(isstrprop(x,'alphanum')),stressData(1,:),'UniformOutput',false); %removes spaces & illegal characters from variable names
%% create table and add new cols
stressDataTable = cell2table(stressData(2:end,:),'VariableNames',varNames);
stressDataTable.PropCorrect = ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH)) ./ (stressDataTable.NUMTRIALS);
stressDataTable.PropPrem = (stressDataTable.NUMPREMATURE)./(stressDataTable.NUMTRIALS);
stressDataTable.PropOmit = (stressDataTable.NUMOMISSIONS) ./ (stressDataTable.NUMTRIALS);
%% get mean proportions separated by group,genotype, and session type
stressDataArray = grpstats(stressDataTable,{'GROUP','Genotype','SessionType'},{'mean','std'},'DataVars',{'PropCorrect','PropPrem','PropOmit'});
%% run statistics
% ranovatbl = ranova(rm); % repeated measures ANOVA
% c = multcompare(stats,Name,Value); % post-hoc test
%% create graphs
figure(1);
subplot(3,1,1);
%c = categorical({'Non-Tg Continuous', 'Tg Continuous','Non-Tg Intermittent','Tg Intermittent'});
%bar([stressDataArray{1:6,5}; stressDataArray{7:12,5}; stressDataArray{13:18,5}; stressDataArray{19:24,5}]); 
hold on
ylim([0 1.0]);
title('Proportion Correct');
subplot(3,1,2);
bar([NTgCont],[TgCont],[NTgInt],[TgInt]);
title('Proportion Premature');
subplot(3,1,3);
bar([NTgCont],[TgCont],[NTgInt],[TgInt]);
title('Proportion Omitted');