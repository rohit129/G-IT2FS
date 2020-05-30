%% g_antonym


%% x: 4 points of x.. (a, b, c, d)

function[MFs] = g_antonym(x)

mean1=x(1);
mean2=x(2);
std_x=x(3);
classIT2FS= x(4);

new_mean1= 10-x(1);
new_mean2= 10-x(2);

if classIT2FS == 0
    new_classIT2FS=2;
elseif classIT2FS==2
    new_classIT2FS=0;
else
    new_classIT2FS=1;
end

MFs=[new_mean2 new_mean1 std_x new_classIT2FS];

return;

