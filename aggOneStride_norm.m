function input_w = aggOneStride_norm(events,thigh,chest)

stride_start = floor(events.strideStart*31.25);
stride_end = floor(events.strideEnd*31.25);

mask = stride_end > length(thigh);
stride_end(mask) = length(thigh);

% Normalize thigh and chest data
mean_chest = mean(chest,2);
std_chest = std(chest,0,2);
mean_thigh = mean(thigh,2);
std_thigh = std(thigh,0,2);

thigh = (thigh-mean_thigh)./std_thigh;
chest = (chest-mean_chest)./std_chest;

z_t = thigh(3,stride_start(1):stride_end(1));
x_t = thigh(1,stride_start(1):stride_end(1));
y_t = thigh(2,stride_start(1):stride_end(1));

z_c = chest(3,stride_start(1):stride_end(1));
x_c = chest(1,stride_start(1):stride_end(1));
y_c = chest(2,stride_start(1):stride_end(1));
n = length(z_t);

data_chest = [x_c;y_c;z_c];
data_thigh = [x_t;y_t;z_t];

input_w = [data_thigh; data_chest;];

end