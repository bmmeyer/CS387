% Build individual inputs with 4 strides in each
% requires data that has already been classified with walking extracted
% data will be kept offline for IRB reasons
clear; clc
path = fullfile(pwd,'Session 1 Long Walking Bouts 4 Strides');
tbl = readtable('ms_fall_study_session1_final.xlsx');
d = dir(path);
k = 1; while k <= numel(d); if d(k).name(1) == '.'; d(k) = []; else; k = k+1; end; end
fn = {d.name};
% ask user to select which subjects they would like to process
[indx,tf] = listdlg('PromptString',{'Select a file.',...
    'Only one file can be selected at a time.',''},...
    'SelectionMode','multiple','ListString',fn);
agg_str = [];
c = 1;
for n = 1:length(indx)
    pathIn = fullfile(path,fn{indx(n)});
    sub = fn{indx(n)}(1:5);
    disp(sub)
    
    for t = 1:size(tbl,1)
        if strcmp(tbl{t,3},sub)
            fall = categorical(tbl{t,2});
            abc = tbl.ABC(t);
            break;
        end
    end%t
    
    load(pathIn)
    for b = 1:numel(long_bouts)
        if length(long_bouts(b).strides.strideStart) < 2
        else
            s_time = datetime(long_bouts(b).startTime,'ConvertFrom','posixtime');
            start_time = s_time.Hour + s_time.Minute/60 + s_time.Second/3600;
            dt = (0.032)/3600;
            len = length(long_bouts(b).chest_acc);
            end_time = start_time + (dt*len);
            bout_time = linspace(start_time,end_time,len);
            ABC = ones(floor(len),1) * abc;
            agg_str{c} = [ABC';bout_time;normalize(long_bouts(b).thigh_acc);normalize(long_bouts(b).chest_acc)];
            sub_ind(c) = n;
            sub_name{c} = sub;
            fall_labels(c) = fall;
            c = c + 1;
        end
    end
end
agg_str = agg_str';
sub_ind = sub_ind';
sub_name = sub_name';
fall_labels = fall_labels';