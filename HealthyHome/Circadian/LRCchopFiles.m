function LRCchopFiles
%LRCCHOPFILES Summary of this function goes here
%   Detailed explanation goes here

arPath = fullfile(pwd,'activityReading.csv');
lrPath = fullfile(pwd,'lightReading.csv');

runTimeUTC = [1446437114;1446441885;1446451488;1446474304];

AR = readtable(arPath);
LR = readtable(lrPath);

for i1 = 1:numel(runTimeUTC);
    arIdx = AR.timeUTC <= runTimeUTC(i1);
    lrIdx = LR.timeUTC <= runTimeUTC(i1);
    
    arTemp = AR(arIdx,:);
    lrTemp = LR(lrIdx,:);
    
    arFilename = fullfile(pwd,['activityReading_',num2str(i1),'.csv']);
    lrFilename = fullfile(pwd,['lightReading_',num2str(i1),'.csv']);
    
    writetable(arTemp,arFilename);
    writetable(lrTemp,lrFilename);
end

end

