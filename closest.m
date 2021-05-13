function [t_close] = closest(time,t_target)
[~,idx] = min(abs(time - t_target));
t_close = time(idx);
end