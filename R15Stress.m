% Import data file
[~,~,stressData] = xlsread('/Users/giulianadimarco/Documents/Texas Tech/Research/Data/R15StressData.xlsx','R15StressData');
varNames = cellfun(@(x) x(isstrprop(x,'alphanum')),stressData(1,:),'UniformOutput',false); %removes spaces & illegal characters from variable names
%% create table and add new cols
stressDataTable = cell2table(stressData(2:end,:),'VariableNames',varNames);
stressDataTable.PropCorrect = ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH)) ./ (stressDataTable.NUMTRIALS);
stressDataTable.PropPrem = (stressDataTable.NUMPREMATURE)./(stressDataTable.NUMTRIALS);
stressDataTable.PropOmit = (stressDataTable.NUMOMISSIONS) ./ (stressDataTable.NUMTRIALS);
%% get totals for Non-Tg Cont Correct graphs
corrNTgCPreW = mean(stressDataTable{:,'PropCorrect'});
premNTgCPreWat = mean(stressDataTable{:,'PropPrem'});
omitNTgCPreW = mean(stressDataTable{:,'PropOmit'});

nTgCWat = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'water stress'));
corrNTgCWat = mean(nTgCWat{:,'PropCorrect'});
premNTgCWat = mean(nTgCWat{:,'PropPrem'});
omitNTgCWat = mean(nTgCWat{:,'PropOmit'});

nTgCPostW = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'post water stress'));
corrNTgCPostW = mean(nTgCPostW{:,'PropCorrect'});
premNTgCPostW = mean(nTgCPostW{:,'PropPrem'});
omitNTgCPostW = mean(nTgCPostW{:,'PropOmit'});

nTgCPreO = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'pre odor stress'));
corrNTgCPreO = mean(nTgCPreO{:,'PropCorrect'});
premNTgCPreO = mean(nTgCPreO{:,'PropPrem'});
omitNTgCPreO = mean(nTgCPreO{:,'PropOmit'});

nTgCOdor = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'odor stress'));
corrNTgCOdor = mean(nTgCOdor{:,'PropCorrect'});
premNTgCOdor = mean(nTgCOdor{:,'PropPrem'});
omitNTgCOdor = mean(nTgCOdor{:,'PropOmit'});

nTgCPostO = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'post odor stress'));
corrNTgCPostO = mean(nTgCPostO{:,'Prop_Correct'});
premNTgCPostO = mean(nTgCPostO{:,'Prop_Prem'});
omitNTgCPostO = mean(nTgCPostO{:,'Prop_Omit'});
%% get totals for Tg Cont graphs
onlyTgCont = stressDataTable(strcmpi(stressDataTable.Genotype, 'Tg') & strcmpi(stressDataTable.GROUP, '3CSRTT-C'));
%% get totals for Non-Tg Int Graphs
onlyNTgInt = stressDataTable(strcmpi(stressDataTable.Genotype, 'Non-Tg') & strcmpi(stressDataTable.GROUP, '3CSRTT-I'));
%% get totals for Tg Int Graphs
onlyTgInt = stressDataTable(strcmpi(stressDataTable.Genotype, 'Tg') & strcmpi(stressDataTable.GROUP, '3CSRTT-I'));
%% run statistics
ranovatbl = ranova(rm); % repeated measures ANOVA
c = multcompare(stats,Name,Value); % post-hoc test
%% create graphs
figure;
subplot(3,1,1);
bar([NTgCont],[TgCont],[NTgInt],[TgInt]); 
title('Proportion Correct');
subplot(3,1,2);
bar([NTgCont],[TgCont],[NTgInt],[TgInt]);
title('Proportion Premature');
subplot(3,1,3);
bar([NTgCont],[TgCont],[NTgInt],[TgInt]);
title('Proportion Omitted');