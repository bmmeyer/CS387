function input_w = aggNineStrides_norm(events,thigh,chest)

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

z_t7 = thigh(3,stride_start(7):stride_end(7));
x_t7 = thigh(1,stride_start(7):stride_end(7));
y_t7 = thigh(2,stride_start(7):stride_end(7));

z_c7 = chest(3,stride_start(7):stride_end(7));
x_c7 = chest(1,stride_start(7):stride_end(7));
y_c7 = chest(2,stride_start(7):stride_end(7));
n7 = length(z_t7);

data_chest7 = [x_c7;y_c7;z_c7];
data_thigh7 = [x_t7;y_t7;z_t7];

z_t8 = thigh(3,stride_start(8):stride_end(8));
x_t8 = thigh(1,stride_start(8):stride_end(8));
y_t8 = thigh(2,stride_start(8):stride_end(8));

z_c8 = chest(3,stride_start(8):stride_end(8));
x_c8 = chest(1,stride_start(8):stride_end(8));
y_c8 = chest(2,stride_start(8):stride_end(8));
n8 = length(z_t8);

data_chest8 = [x_c8;y_c8;z_c8];
data_thigh8 = [x_t8;y_t8;z_t8];

z_t9 = thigh(3,stride_start(9):stride_end(9));
x_t9 = thigh(1,stride_start(9):stride_end(9));
y_t9 = thigh(2,stride_start(9):stride_end(9));

z_c9 = chest(3,stride_start(9):stride_end(9));
x_c9 = chest(1,stride_start(9):stride_end(9));
y_c9 = chest(2,stride_start(9):stride_end(9));
n9 = length(z_t9);

data_chest9 = [x_c9;y_c9;z_c9];
data_thigh9 = [x_t9;y_t9;z_t9];
% pad stride lengths


st_lengths = [n n2 n3 n4 n5 n6 n7 n8 n9];
[~,m_ind] = max(st_lengths);

if m_ind == 1
    diff1 = n-n2;
    diff2 = n-n3;
    diff3 = n-n4;
    diff4 = n-n5;
    diff5 = n - n6;
    diff6 = n-n7;
    diff7 = n-n8;
    diff8 = n-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 2
    diff1 = n2 - n;
    diff2 = n2 - n3;
    diff3 = n2 - n4;
    diff4 = n2 - n5;
    diff5 = n2 - n6;
    diff6 = n2 - n7;
    diff7 = n2 - n8;
    diff8 = n2-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 3
    diff1 = n3 - n;
    diff2 = n3 - n2;
    diff3 = n3 - n4;
    diff4 = n3 - n5;
    diff5 = n3 - n6;
    diff6 = n3 - n7;
    diff7 = n3 - n8;
    diff8 = n3-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 4
    diff1 = n4-n;
    diff2 = n4-n2;
    diff3 = n4-n3;
    diff4 = n4-n5;
    diff5 = n4-n6;
    diff6 = n4-n7;
    diff7 = n4 - n8;
    diff8 = n4-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 5
    diff1 = n5-n;
    diff2 = n5-n2;
    diff3 = n5-n3;
    diff4 = n5-n4;
    diff5 = n5-n6;
    diff6 = n5-n7;
    diff7 = n5 - n8;
    diff8 = n5-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 6
    diff1 = n6-n;
    diff2 = n6-n2;
    diff3 = n6-n3;
    diff4 = n6-n4;
    diff5 = n6-n5;
    diff6 = n6-n7;
    diff7 = n6 - n8;
    diff8 = n6-n9;
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
    data_chest7 = addzeros(data_chest7,diff6);
    data_thigh7 = addzeros(data_thigh7,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 7
    diff1 = n7-n;
    diff2 = n7-n2;
    diff3 = n7-n3;
    diff4 = n7-n4;
    diff5 = n7-n5;
    diff6 = n7-n6;
    diff7 = n7-n8;
    diff8 = n7-n9;
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
    data_chest6 = addzeros(data_chest6,diff6);
    data_thigh6 = addzeros(data_thigh6,diff6);
    data_chest8 = addzeros(data_chest8,diff7);
    data_thigh8 = addzeros(data_thigh8,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 8
    diff1 = n8-n;
    diff2 = n8-n2;
    diff3 = n8-n3;
    diff4 = n8-n4;
    diff5 = n8-n5;
    diff6 = n8-n6;
    diff7 = n8-n7;
    diff8 = n8-n9;
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
    data_chest6 = addzeros(data_chest6,diff6);
    data_thigh6 = addzeros(data_thigh6,diff6);
    data_chest7 = addzeros(data_chest7,diff7);
    data_thigh7 = addzeros(data_thigh7,diff7);
    data_chest9 = addzeros(data_chest9,diff8);
    data_thigh9 = addzeros(data_thigh9,diff8);
elseif m_ind == 9
    diff1 = n9-n;
    diff2 = n9-n2;
    diff3 = n9-n3;
    diff4 = n9-n4;
    diff5 = n9-n5;
    diff6 = n9-n6;
    diff7 = n9-n7;
    diff8 = n9-n8;
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
    data_chest6 = addzeros(data_chest6,diff6);
    data_thigh6 = addzeros(data_thigh6,diff6);
    data_chest7 = addzeros(data_chest7,diff7);
    data_thigh7 = addzeros(data_thigh7,diff7);
    data_chest8 = addzeros(data_chest8,diff8);
    data_thigh8 = addzeros(data_thigh8,diff8);
end

input_w = [data_thigh; data_thigh2; data_thigh3; data_thigh4; data_thigh5; data_thigh6; data_thigh7; data_thigh8; data_thigh9; data_chest; data_chest2; data_chest3; data_chest4; data_chest5; data_chest6; data_chest7; data_chest8; data_chest9];

end