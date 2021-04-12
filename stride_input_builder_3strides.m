% Build individual inputs with 3 strides in each
% requires data that has already been classified with walking extracted
% data will be kept offline for IRB reasons
clear; clc
path = fullfile(pwd,'Session 1 3 strides per bout');
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
            break;
        end
    end%t
    
    load(pathIn)
    for b = 1:numel(short_bouts)
        if length(short_bouts(b).strides.strideStart) < 3
        else
            agg_str{c} = aggThreeStrides_norm(short_bouts(b).strides,short_bouts(b).thigh_acc,short_bouts(b).chest_acc);
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