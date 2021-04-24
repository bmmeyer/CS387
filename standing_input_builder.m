clear; clc
path = fullfile(pwd,'Session 1 Standing');
tbl = readtable('ms_fall_study_session1_final.xlsx');
d = dir(path);
k = 1; while k <= numel(d); if d(k).name(1) == '.'; d(k) = []; else; k = k+1; end; end
fn = {d.name};
% ask user to select which subjects they would like to process
[indx,tf] = listdlg('PromptString',{'Select a file.',...
    'Only one file can be selected at a time.',''},...
    'SelectionMode','multiple','ListString',fn);
window_dur = 4;
slide = 1; %set to one to slide the window dur, 2 for 1/2 window slide, 4 for 1/4
agg_stand = [];
agg_stand_noZ = [];
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
    
    for b = 1:numel(standing_bouts)
        if standing_bouts(b).duration >= 60
            num_loops = floor(standing_bouts(b).duration/window_dur)*slide;
            for k = 1:num_loops
                if k == 1
                    start = 1;
                    end_ind = 31.25 * window_dur;
                    ABC = ones(floor(31.25 * window_dur),1) * abc;
                    agg_stand{c} = [ABC'; standing_bouts(b).thigh_acc(:,1:end_ind);standing_bouts(b).chest_acc(:,1:end_ind)];
                    agg_stand_noZ{c} = [ABC'; standing_bouts(b).thigh_acc(1:2,1:end_ind);standing_bouts(b).chest_acc(1:2,1:end_ind)];
                    sub_ind(c) = n;
                    sub_name{c} = sub;
                    fall_labels(c) = fall;
                    c = c + 1;
                else
                    start = (k-1) * (125/slide) + 1;
                    end_ind = (start-1) + floor(window_dur * 31.25); %assuming 31.25Hz sampling rate
                    ABC = ones(floor(31.25 * window_dur),1) * abc;
                    agg_stand{c} = [ABC'; standing_bouts(b).thigh_acc(:,start:end_ind);standing_bouts(b).chest_acc(:,start:end_ind)];
                    agg_stand_noZ{c} = [ABC'; standing_bouts(b).thigh_acc(1:2,start:end_ind);standing_bouts(b).chest_acc(1:2,start:end_ind)];
                    sub_ind(c) = n;
                    sub_name{c} = sub;
                    fall_labels(c) = fall;
                    c = c + 1;
                end
                
            end%k
        end % if dur
    end
    
end % n

agg_stand = agg_stand';
agg_stand_noZ = agg_stand_noZ';
sub_ind = sub_ind';
sub_name = sub_name';
fall_labels = fall_labels';