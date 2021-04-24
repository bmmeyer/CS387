% Build individual inputs with 3 strides in each
% requires data that has already been classified with walking extracted
% data will be kept offline for IRB reasons
clear; clc
path = fullfile(pwd,'Session 1 all bouts');
tbl = readtable('ms_fall_study_session1_final.xlsx');
d = dir(path);
k = 1; while k <= numel(d); if d(k).name(1) == '.'; d(k) = []; else; k = k+1; end; end
fn = {d.name};
% ask user to select which subjects they would like to process
[indx,tf] = listdlg('PromptString',{'Select a file.',...
    'Only one file can be selected at a time.',''},...
    'SelectionMode','multiple','ListString',fn);
agg_str = [];agg_str_abc = [];
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
    for b = 1:numel(short_bouts)
        num_strides = length(short_bouts(b).strides.strideStart);
        if num_strides < 3
        else
            for j = 1:floor(num_strides/1)
            events.strideStart = short_bouts(b).strides.strideStart(j);
            events.strideEnd = short_bouts(b).strides.strideEnd(j);
            agg_str{c} = aggOneStride_norm(events,short_bouts(b).thigh_acc,short_bouts(b).chest_acc);
            ABC = ones(size(agg_str{c},2),1) * abc;
            agg_str_abc{c} = [ABC'; agg_str{c}];
            sub_ind(c) = n;
            sub_name{c} = sub;
            fall_labels(c) = fall;
            c = c + 1;
            end
        end
    end
end
agg_str_abc = agg_str_abc';
agg_str = agg_str';
sub_ind = sub_ind';
sub_name = sub_name';
fall_labels = fall_labels';
num_subs = length(unique(sub_ind));