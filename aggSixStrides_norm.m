function input_w = aggSixStrides_norm(events,thigh,chest)

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

z_t4 = thigh(3,stride_start(4):stride_end(4));
x_t4 = thigh(1,stride_start(4):stride_end(4));
y_t4 = thigh(2,stride_start(4):stride_end(4));

z_c4 = chest(3,stride_start(4):stride_end(4));
x_c4 = chest(1,stride_start(4):stride_end(4));
y_c4 = chest(2,stride_start(4):stride_end(4));
n4 = length(z_t4);

data_chest4 = [x_c4;y_c4;z_c4];
data_thigh4 = [x_t4;y_t4;z_t4];

z_t5 = thigh(3,stride_start(5):stride_end(5));
x_t5 = thigh(1,stride_start(5):stride_end(5));
y_t5 = thigh(2,stride_start(5):stride_end(5));

z_c5 = chest(3,stride_start(5):stride_end(5));
x_c5 = chest(1,stride_start(5):stride_end(5));
y_c5 = chest(2,stride_start(5):stride_end(5));
n5 = length(z_t5);

data_chest5 = [x_c5;y_c5;z_c5];
data_thigh5 = [x_t5;y_t5;z_t5];

z_t6 = thigh(3,stride_start(6):stride_end(6));
x_t6 = thigh(1,stride_start(6):stride_end(6));
y_t6 = thigh(2,stride_start(6):stride_end(6));

z_c6 = chest(3,stride_start(6):stride_end(6));
x_c6 = chest(1,stride_start(6):stride_end(6));
y_c6 = chest(2,stride_start(6):stride_end(6));
n6 = length(z_t6);

data_chest6 = [x_c6;y_c6;z_c6];
data_thigh6 = [x_t6;y_t6;z_t6];
% pad stride lengths


st_lengths = [n n2 n3 n4 n5 n6];
[~,m_ind] = max(st_lengths);

if m_ind == 1
    diff1 = n-n2;
    diff2 = n-n3;
    diff3 = n-n4;
    diff4 = n-n5;
    diff5 = n - n6;
    data_chest2 = addzeros(data_chest2,diff1);
    data_thigh2 = addzeros(data_thigh2,diff1);
    data_chest3 = addzeros(data_chest3,diff2);
    data_thigh3 = addzeros(data_thigh3,diff2);
    data_chest4 = addzeros(data_chest4,diff3);
    data_thigh4 = addzeros(data_thigh4,diff3);
    data_chest5 = addzeros(data_chest5,diff4);
    data_thigh5 = addzeros(data_thigh5,diff4);
    data_chest6 = addzeros(data_chest6,diff5);
    data_thigh6 = addzeros(data_thigh6,diff5);
elseif m_ind == 2
    diff1 = n2 - n;
    diff2 = n2 - n3;
    diff3 = n2 - n4;
    diff4 = n2 - n5;
    diff5 = n2 - n6;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest3 = addzeros(data_chest3,diff2);
    data_thigh3 = addzeros(data_thigh3,diff2);
    data_chest4 = addzeros(data_chest4,diff3);
    data_thigh4 = addzeros(data_thigh4,diff3);
    data_chest5 = addzeros(data_chest5,diff4);
    data_thigh5 = addzeros(data_thigh5,diff4);
    data_chest6 = addzeros(data_chest6,diff5);
    data_thigh6 = addzeros(data_thigh6,diff5);
elseif m_ind == 3
    diff1 = n3 - n;
    diff2 = n3 - n2;
    diff3 = n3 - n4;
    diff4 = n3 - n5;
    diff5 = n3 - n6;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest2 = addzeros(data_chest2,diff2);
    data_thigh2 = addzeros(data_thigh2,diff2);
    data_chest4 = addzeros(data_chest4,diff3);
    data_thigh4 = addzeros(data_thigh4,diff3);
    data_chest5 = addzeros(data_chest5,diff4);
    data_thigh5 = addzeros(data_thigh5,diff4);
    data_chest6 = addzeros(data_chest6,diff5);
    data_thigh6 = addzeros(data_thigh6,diff5);
elseif m_ind == 4
    diff1 = n4-n;
    diff2 = n4-n2;
    diff3 = n4-n3;
    diff4 = n4-n5;
    diff5 = n4-n6;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest2 = addzeros(data_chest2,diff2);
    data_thigh2 = addzeros(data_thigh2,diff2);
    data_chest3 = addzeros(data_chest3,diff3);
    data_thigh3 = addzeros(data_thigh3,diff3);
    data_chest5 = addzeros(data_chest5,diff4);
    data_thigh5 = addzeros(data_thigh5,diff4);
    data_chest6 = addzeros(data_chest6,diff5);
    data_thigh6 = addzeros(data_thigh6,diff5);
elseif m_ind == 5
    diff1 = n5-n;
    diff2 = n5-n2;
    diff3 = n5-n3;
    diff4 = n5-n4;
    diff5 = n5-n6;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest2 = addzeros(data_chest2,diff2);
    data_thigh2 = addzeros(data_thigh2,diff2);
    data_chest3 = addzeros(data_chest3,diff3);
    data_thigh3 = addzeros(data_thigh3,diff3);
    data_chest4 = addzeros(data_chest4,diff4);
    data_thigh4 = addzeros(data_thigh4,diff4);
    data_chest6 = addzeros(data_chest6,diff5);
    data_thigh6 = addzeros(data_thigh6,diff5);
elseif m_ind == 6
    diff1 = n6-n;
    diff2 = n6-n2;
    diff3 = n6-n3;
    diff4 = n6-n4;
    diff5 = n6-n5;
    data_chest = addzeros(data_chest,diff1);
    data_thigh = addzeros(data_thigh,diff1);
    data_chest2 = addzeros(data_chest2,diff2);
    data_thigh2 = addzeros(data_thigh2,diff2);
    data_chest3 = addzeros(data_chest3,diff3);
    data_thigh3 = addzeros(data_thigh3,diff3);
    data_chest4 = addzeros(data_chest4,diff4);
    data_thigh4 = addzeros(data_thigh4,diff4);
    data_chest5 = addzeros(data_chest5,diff5);
    data_thigh5 = addzeros(data_thigh5,diff5);
end

input_w = [data_thigh; data_thigh2; data_thigh3; data_thigh4; data_thigh5; data_thigh6; data_chest; data_chest2; data_chest3; data_chest4; data_chest5; data_chest6];

end