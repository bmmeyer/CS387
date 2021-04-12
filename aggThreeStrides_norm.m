function input_w = aggThreeStrides_norm(events,thigh,chest)

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

z_t2 = thigh(3,stride_start(2):stride_end(2));
x_t2 = thigh(1,stride_start(2):stride_end(2));
y_t2 = thigh(2,stride_start(2):stride_end(2));

z_c2 = chest(3,stride_start(2):stride_end(2));
x_c2 = chest(1,stride_start(2):stride_end(2));
y_c2 = chest(2,stride_start(2):stride_end(2));
n2 = length(z_t2);

data_chest2 = [x_c2;y_c2;z_c2];
data_thigh2 = [x_t2;y_t2;z_t2];


z_t3 = thigh(3,stride_start(3):stride_end(3));
x_t3 = thigh(1,stride_start(3):stride_end(3));
y_t3 = thigh(2,stride_start(3):stride_end(3));

z_c3 = chest(3,stride_start(3):stride_end(3));
x_c3 = chest(1,stride_start(3):stride_end(3));
y_c3 = chest(2,stride_start(3):stride_end(3));
n3 = length(z_t3);

data_chest3 = [x_c3;y_c3;z_c3];
data_thigh3 = [x_t3;y_t3;z_t3];

% pad stride lengths


st_lengths = [n n2 n3];
[~,m_ind] = max(st_lengths);

if m_ind == 1
    diff1 = n-n2;
    diff2 = n-n3;
    data_chest2 = addzeros(data_chest2,diff1);
    data_thigh2 = addzeros(data_thigh2,diff1);
    data_chest3 = addzeros(data_chest3,diff2);
    data_thigh3 = addzeros(data_thigh3,diff2);
elseif m_ind == 2
    diff1 = n2 - n;
    diff2 = n2 - n3;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest3 = addzeros(data_chest3,diff2);
    data_thigh3 = addzeros(data_thigh3,diff2);
elseif m_ind == 3
    diff1 = n3 - n;
    diff2 = n3 - n2;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest2 = addzeros(data_chest2,diff2);
    data_thigh2 = addzeros(data_thigh2,diff2);
end

input_w = [data_thigh; data_thigh2; data_thigh3; data_chest; data_chest2; data_chest3];

end