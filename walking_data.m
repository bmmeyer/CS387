clear;clc
ok = questdlg('Select the directory the classified data','Get Directory','OK','OK');
if isempty(ok); error('process ended'); end
path = uigetdir();
pathOut = fullfile(pwd,'Session 1 3 strides per bout');
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
nMinimumStridesPerBout = 3;

for n = 1:length(indx)
    pathIn = fullfile(path,fn{indx(n)});
    disp(fn{indx(n)})
    load(pathIn)
    
    count = 1;
    for i = 1:numel(bout)
        if bout(i).duration <= 12 && bout(i).label == 1
            short_bouts(count) = bout(i);
            count = count + 1;
        end
    end
    
    % Now I need to loop through each bout and see if I can find 4 strides
    % from them
    
    if exist('short_bouts','var') ~= 0
        
        b = 1;
        while b <= numel(short_bouts)
            time = linspace(0,short_bouts(b).duration,length(short_bouts(b).thigh_acc));
            [ events ] = getGaitEvents_MC10HD_ccThighAccelerometer_T25FW_Jan2021(short_bouts(b).thigh_acc(3,:),...
                short_bouts(b).chest_acc(3,:),...
                subject.info.sf,...
                time,...
                minimumStrideTime,...
                maximumStrideTime,...
                nMinimumStridesPerBout,...
                minimumDutyFactor,maximumDutyFactor);
            
            if events.deleteBout
                short_bouts(b) = [];
            else
                short_bouts(b).strides = events;
                b = b + 1;
            end
            
        end
        
        save(fullfile(pathOut,strcat(fn{indx(n)}(1:5),'_strides.mat')),'short_bouts')
        clear short_bouts
    end
end