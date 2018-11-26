%% Import data file
[~,~,stressData] = xlsread('/Users/giulianadimarco/Documents/Texas Tech/Research/Data/R15StressData.xlsx','R15StressData');
varNames = isstrprop(stressData{1,1:end},'alphanum'); %removes spaces & illegal characters from variable names
%% create table and add new cols
dataTable = array2table(stressData(2:end,:),'VariableNames',varNames);
dataTable.Prop_Correct = ((dataTable.NUMCORRECTDURINGSTIMULUS + dataTable.NUMCORRECTDURINGLH) ./ dataTable.NUMTRIALS);
dataTable.Prop_Prem = dataTable.NUMPREMATURE ./ dataTable.NUMTRIALS;
dataTable.Prop_Omit = dataTable.NUMOMISSIONS ./ dataTable.NUMTRIALS;
%% remove any numbers over 1
i = 1:length(dataTable.Prop_Correct);
if i > 1
   i = NaN;
end
%% get totals for Non-Tg Cont Correct graphs
onlyNTgCont = dataTable(strcmpi(dataTable.Genotype, 'Non-Tg') & strcmpi(dataTable.GROUP, '3CSRTT-C'));
nTgCPreW = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'pre water stress'));
corrNTgCPreW = mean(nTgCPreW{'Prop_Correct',:});
premNTgCPreWat = mean(nTgCPreW{'Prop_Prem',:});
omitNTgCPreW = mean(nTgCPreW{'Prop_Omit',:});

nTgCWat = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'water stress'));
corrNTgCWat = mean(nTgCWat{'Prop_Correct',:});
premNTgCWat = mean(nTgCWat{'Prop_Prem',:});
omitNTgCWat = mean(nTgCWat{'Prop_Omit',:});

nTgCPostW = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'post water stress'));
corrNTgCPostW = mean(nTgCPostW{'Prop_Correct',:});
premNTgCPostW = mean(nTgCPostW{'Prop_Prem',:});
omitNTgCPostW = mean(nTgCPostW{'Prop_Omit',:});

nTgCPreO = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'pre odor stress'));
corrNTgCPreO = mean(nTgCPreO{'Prop_Correct',:});
premNTgCPreO = mean(nTgCPreO{'Prop_Prem',:});
omitNTgCPreO = mean(nTgCPreO{'Prop_Omit',:});

nTgCOdor = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'odor stress'));
corrNTgCOdor = mean(nTgCOdor{'Prop_Correct',:});
premNTgCOdor = mean(nTgCOdor{'Prop_Prem',:});
omitNTgCOdor = mean(nTgCOdor{'Prop_Omit',:});

nTgCPostO = onlyNTgCont(strcmpi(onlyNTgCont.SessionType, 'post odor stress'));
corrNTgCPostO = mean(nTgCPostO{'Prop_Correct',:});
premNTgCPostO = mean(nTgCPostO{'Prop_Prem',:});
omitNTgCPostO = mean(nTgCPostO{'Prop_Omit',:});
%% get totals for Tg Cont graphs
onlyTgCont = dataTable(strcmpi(dataTable.Genotype, 'Tg') & strcmpi(dataTable.GROUP, '3CSRTT-C'));
%% get totals for Non-Tg Int Graphs
onlyNTgInt = dataTable(strcmpi(dataTable.Genotype, 'Non-Tg') & strcmpi(dataTable.GROUP, '3CSRTT-I'));
%% get totals for Tg Int Graphs
onlyTgInt = dataTable(strcmpi(dataTable.Genotype, 'Tg') & strcmpi(dataTable.GROUP, '3CSRTT-I'));
%% run statistics
ranovatbl = ranova(rm); % repeated measures ANOVA
c = multcompare(stats,Name,Value); % post-hoc test
%% create graphs
figure;
subplot(3,1,1);
bar([corrNTgCPreW,corrNTgCWat,corrNTgCPostW,corrNTgCPreO,corrNTgCOdor,corrNTgCPostO],[TgCont],[NonTgInt],[TgInt]);
% add standard error bars
% chage colors
% add * 
subplot(3,1,2);
bar([premNTgCPreW,premNTgCWat,premNTgCPostW,premNTgCPreO,premNTgCOdor,premNTgCPostO],[TgCont],[NonTgInt],[TgInt]);
subplot(3,1,3);
bar([omitNTgCPreW,omitNTgCWat,omitNTgCPostW,omitNTgCPreO,omitNTgCOdor,omitNTgCPostO],[TgCont],[NonTgInt],[TgInt]);