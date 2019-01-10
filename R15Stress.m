function [ranovatbl, tukeystblSessionType, tukeystblSubject] = R15Stress(filename)
%% Help Documentation
% This function was created to analyze and graph data from the stress
% sessions of the R15 grant project in the Harris/Soto lab at Texas Tech.
%
% R15Stress creates a table from the input excel file. Then proportion
% correct, proportion premature, proportion omitted, and perserverative data
% are generated in new columns on the table using the current data in the
% excel sheet. Next data is arranged by group, genotype, and session
% type. The function then runs a repeated measures anova, Tukey's post-hoc test, graphs the data,
% and prints the results. Graphs are set to JNeuroscience
% requirements.
%
% Repeated Measures Model Information:
%   Wilkinson Notation for fitrm: 'odorstress-waterstress~SUBJECT-1'
%   Within Design Model
%
% INPUTS: filename must be an excel spread sheet
%       **if there are mutiple sheets in the excel file, the function will prompt you to enter which sheet you want to use**
% OUTPUTS: 
%   R15Stress(filename) prints only data graphs in an eps format 
%   ranovatbl = R15Stress(filename) prints data graphs and repeated measures anova results, and tukey's post hoc test results
%   [ranovatbl, tukeystbl] = R15Stress(filename) prints data graphs, repeated measures anova results, and tukeys post hoc test comparing session type
%   [ranovatbl, tukeystblSessionType, tukeystblSubject] = R15Stress(filename) prints data graphs, repeated measures anova results, tukeys post hoc test comparing session type, and tukeys post hoc test comparing subjects
% 
% Anova and Post Hoc Result Tables are in the following order (column-wise):
%   1. Proportion Correct
%   2. Ratio Perserverative Correct
%   3. Proportion Premature
%   4. Ratio Perserverative Premature
%   5. Proportion Omitted
%   6. Ratio Perserverative Omitted

%% Check if input file exists & check that the input file is an excel file
if ~exist(filename,'file')
   error('Input file does not exist. Please input a file that exists.');
else 
   [xlsFileStatus, xlsSheetNames] = xlsfinfo(filename);
   if strcmpi(xlsFileStatus, '')
      error('Input file is not an excel spreadsheet. Please input an excel file.');
   end
end

% Determine which sheet in the excel file to use
numSheets = length(xlsSheetNames);
if numSheets == 1
   xlsSheet = cell2mat(xlsSheetNames);
else
   userResp = input('This excel file has multiple sheets. Please type the name of the sheet you wish to use.\n','s');
   compUserInput = strcmpi(xlsSheetNames,userResp);
   if any(compUserInput)
      xlsSheet = userResp;
   else
      error('This sheet does not exist. Please input a valid sheet name');
   end
end

%% Import data file and edit variable names for proper table format
[~,~,stressData] = xlsread(filename,xlsSheet);
varNames = cellfun(@(x) x(isstrprop(x,'alphanum')),stressData(1,:),'UniformOutput',false); %removes spaces & illegal characters from variable names for valid table names
sessTypeNames = cellfun(@(x) x(isstrprop(x, 'alphanum')), stressData(2:end,8), 'UniformOutput', false); %remove spaces from session type names for reorganized data tables

%% Use imported data to create a table and add cols to find important data 
stressDataTable = cell2table(stressData(2:end,:),'VariableNames',varNames);
stressDataTable.PropCorrect = ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH)) ./ (stressDataTable.NUMTRIALS); %proportion correct responses
stressDataTable.PropPrem = (stressDataTable.NUMPREMATURE)./(stressDataTable.NUMTRIALS); %proportion premature responses
stressDataTable.PropOmit = (stressDataTable.NUMOMISSIONS) ./ (stressDataTable.NUMTRIALS); %proportion omitted responses
stressDataTable.RatioPersCorrect = (stressDataTable.TOTALPOSTRNFRSPS) ./ ((stressDataTable.NUMCORRECTDURINGSTIMULUS) + (stressDataTable.NUMCORRECTDURINGLH)); %ratio perserverative correct responses
stressDataTable.RatioPersPrem = (stressDataTable.TOTALPOSTPREMATURERSPS) ./ (stressDataTable.NUMPREMATURE); %ratio perserverative premature responses
stressDataTable.RatioPersOmit = (stressDataTable.TOTALPOSTOMISSIONTORSPS) ./ (stressDataTable.NUMOMISSIONS); %ratio perserverative omitted responses

%% get mean proportions separated by group, genotype, and session type
stressDataArray = grpstats(stressDataTable,{'GROUP','Genotype','SessionType'},{'mean','std'},'DataVars',{'PropCorrect','PropPrem','PropOmit','RatioPersCorrect','RatioPersPrem','RatioPersOmit'});

%% reorganize data for fitrm, run repeated measures ANOVA, run Tukey's Post-Hoc test
stressDataTable.SessionType = sessTypeNames; %replaces the current session type names with the new ones for valid table names
dataNames = {'PropCorrect','RatioPersCorrect','PropPrem','RatioPersPrem','PropOmit','RatioPersOmit'};
sessionCondition = table([1 2 3 4 5 6]','VariableNames',{'SessionType'});
if nargout >= 1
   ranovatbl = cell(1,6); tukeystblSessionType = cell(1,6); tukeystblSubject = cell(1,6); %preallocation 
   for i = 1:length(dataNames)
       subsetData = stressDataTable(:, {'SUBJECT','SessionType',dataNames{i}}); %generate a subset of only necessary data
       unstackedData = unstack(subsetData,dataNames{i},'SessionType'); %reorganize the data by session type
       cleanUnstackedData = rmmissing(unstackedData); %remove mice who have not completed all stress sessions
       rm = fitrm(cleanUnstackedData,'odorstress-waterstress~SUBJECT-1','WithinDesign',sessionCondition); %fit the repeated measures model
       ranovatbl{i} = ranova(rm); % generate repeated measures anova output if prompted
   if nargout >= 2
      tukeystblSessionType{i} = multcompare(rm,'SessionType'); % Tukey's post-hoc test if prompted for Session Type comparison
      if nargout == 3
         tukeystblSubject{i} = multcompare(rm,'SUBJECT'); % Tukey's post-hoc test if prompted for Subject comparison    
      end
   end
   end
end

%% create bar graphs
categories = categorical({'Non-Tg Continuous', 'Tg Continuous','Non-Tg Intermittent','Tg Intermittent'});
yPlotVars = [stressDataArray.mean_PropCorrect, stressDataArray.mean_RatioPersCorrect, stressDataArray.mean_PropPrem,stressDataArray.mean_RatioPersPrem, stressDataArray.mean_PropOmit, stressDataArray.mean_RatioPersOmit]; 
titles = {'Proportion Correct','Ratio Perservarative Correct','Proportion Premature','Ratio Perserverative Premature','Proportion Omitted','Ratio Perservarative Omitted'};
[~,col] = size(yPlotVars);

figure('Name','R15 Stress Data','NumberTitle','off','PaperUnits','centimeters','PaperSize',[8.5,11],'PaperPosition',[0 0 17.6 28]);
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
end
subplot(3,2,2)
legend(stressDataArray.SessionType(1:6), 'location','northeast');

%% print PDF of graph and stats results
safePrint('R15 Stress Data','-dtiff')