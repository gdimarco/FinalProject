%% Check if file exists

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

%% reorganize data for fitrm and run repeated measures ANOVA 
dataNames = {'PropCorrect','RatioPersCorrect','PropPrem','RatioPersPrem','PropOmit','RatioPersOmit'};
for i = 1:length(dataNames)
    subsetData = stressDataTable(:, {'SUBJECT','SessionType',dataNames{i}});
    unstackedData = unstack(subsetData,dataNames{i},'SessionType');
    dataNames{i} = unstackedData;
end
    
rm = fitrm(CorrUnstackData,'1-y6 ~ GROUP','WithinDesign','SessionType');
%ranovatbl = ranova(rm); % repeated measures ANOVA
%c = multcompare(stats,Name,Value); % post-hoc test
%% create graphs
categories = categorical({'Non-Tg Continuous', 'Tg Continuous','Non-Tg Intermittent','Tg Intermittent'});
yPlotVars = [stressDataArray.mean_PropCorrect, stressDataArray.mean_RatioPersCorrect, stressDataArray.mean_PropPrem,stressDataArray.mean_RatioPersPrem, stressDataArray.mean_PropOmit, stressDataArray.mean_RatioPersOmit]; 
titles = {'Proportion Correct','Ratio Perservarative Correct','Proportion Premature','Ratio Perserverative Premature','Proportion Omitted','Ratio Perservarative Omitted'};
[~,col] = size(yPlotVars);

figure(1);
hold on
for k = 1:col
    subplot(3,2,k);
    bar(categories,[yPlotVars(1:6,k), yPlotVars(7:12,k), yPlotVars(13:18,k),yPlotVars(19:24,k)]');
    title(titles(k));
    if k == 1 || k == 3 || k == 5
       ylim([0 1.0]);
    else 
       ylim([0 2.0]);
    end
    legend(stressDataArray.SessionType(1:6), 'location','northeastoutside');
end