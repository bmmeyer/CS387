clear;clc
ok = questdlg('Select the directory the classified data','Get Directory','OK','OK');
if isempty(ok); error('process ended'); end
path = uigetdir();
pathOut = fullfile(pwd,'Session 1 Standing');
% delete '.' in directory
d = dir(path);
k = 1; while k <= numel(d); if d(k).name(1) == '.'; d(k) = []; else; k = k+1; end; end
fn = {d.name};
% ask user to select which subjects they would like to process
[indx,tf] = listdlg('PromptString',{'Select a file.',...
    'Only one file can be selected at a time.',''},...
    'SelectionMode','multiple','ListString',fn);


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
        
        if bout(i).label == 2 && low_conf == 0
            standing_bouts(count) = bout(i);
            count = count + 1;
        end
    end
    
    
    if exist('standing_bouts','var') ~= 0
        
        save(fullfile(pathOut,strcat(fn{indx(n)}(1:5),'_standing.mat')),'standing_bouts')
        clear standing_bouts
    end
end