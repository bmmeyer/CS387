clear;clc
ok = questdlg('Select the directory the classified data','Get Directory','OK','OK');
if isempty(ok); error('process ended'); end
path = uigetdir();
pathOut = fullfile(pwd,'Session 1 Long Walking Bouts 4 Strides');
% delete '.' in directory
d = dir(path);
k = 1; while k <= numel(d); if d(k).name(1) == '.'; d(k) = []; else; k = k+1; end; end
fn = {d.name};
% ask user to select which subjects they would like to process
[indx,tf] = listdlg('PromptString',{'Select a file.',...
    'Only one file can be selected at a time.',''},...
    'SelectionMode','multiple','ListString',fn);

minimumStrideTime = 0.8910;
maximumStrideTime = 1.64;
minimumDutyFactor = 0.44;
maximumDutyFactor = 0.73;
nMinimumStridesPerBout = 4;

for n = 1:length(indx)
    pathIn = fullfile(path,fn{indx(n)});
    disp(fn{indx(n)})
    load(pathIn)
    
    count = 1;
    for i = 1:numel(bout)
        low_conf = 0;
        for c = 1:numel(bout(i).labelConfidence)
            if bout(i).labelConfidence(c).score < 0.75
                low_conf = 1;
                break;
            end
            
        end
        
        if bout(i).duration >= 32 && bout(i).label == 1 && low_conf == 0
            long_bouts(count) = bout(i);
            count = count + 1;
        end
    end
    
    
    if exist('long_bouts','var') ~= 0
        
        b = 1;
        while b <= numel(long_bouts)
            time = linspace(0,long_bouts(b).duration,length(long_bouts(b).thigh_acc));
            [ events ] = getGaitEvents_MC10HD_ccThighAccelerometer_T25FW_Jan2021(long_bouts(b).thigh_acc(3,:),...
                long_bouts(b).chest_acc(3,:),...
                subject.info.sf,...
                time,...
                minimumStrideTime,...
                maximumStrideTime,...
                nMinimumStridesPerBout,...
                minimumDutyFactor,maximumDutyFactor);
            
            if events.deleteBout
                long_bouts(b) = [];
            else
                long_bouts(b).strides = events;
                b = b + 1;
            end
            
        end
        
        save(fullfile(pathOut,strcat(fn{indx(n)}(1:5),'_strides.mat')),'long_bouts')
        clear long_bouts
    end
end