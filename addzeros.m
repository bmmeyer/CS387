function [out] = addzeros(in,diff)
 pad = zeros(3,diff);
 out = [in pad];
end