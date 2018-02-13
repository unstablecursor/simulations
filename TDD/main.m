%Diffusion coefficient(Micrometers^2/seconds).
coef = 0.122686537;
%Step size. (Seconds).
step = 10^-4;
%Total time. (Seconds).
time = 5;
cell_radius = 5;
flow = [-5, 0, 0];
mol_matrix = normrnd(0, 5, [20000, 3]);
x = mol_matrix;
t = cell_radius./sqrt(sum(x.^2, 2));
mol_matrix = mol_matrix + t.*mol_matrix;

nanobot_coor = [25, 0, 0];
nanobot_radius = 2;
std = sqrt(2 * coef * step);

arrival_times = zeros(20000,1);
coor = zeros(50000,1);
for i = 1:time/step
    %Random movement vector generation.
    movement = normrnd(0, std, size(nanobot_coor));
    nanobot_coor = nanobot_coor + flow * step; % + movement

    %Molecule movementns added to positions.
    
    mol_matrix_temp = mol_matrix;
    %Subtract each molecules position from sphere's coordinates.
    mol_matrix_temp = mol_matrix_temp - nanobot_coor;
    %Square each value
    mol_matrix_temp = mol_matrix_temp.^2;
    %Sum of squares of values.
    sum_vector = sum(mol_matrix_temp, 2);
    %If Sum of squares is smaller or equal to radius^2, then it is a hit.
    hits = (sum_vector <= nanobot_radius^2); %& (arrival_times == 0); For absorbing nanobot
    %Hits is a logical vector that holds 0 for no-hits, 1 for hits.
    
    nanobot_coor_temp = nanobot_coor;
    sum_nano = sum(nanobot_coor_temp.^2);
    if(sum_nano <= (cell_radius * 3)^2)
        coor(i) = 1;
    end
    %Store arrival times.
    arrival_times(hits) = i*step;

end

arrival_times = arrival_times(arrival_times ~= 0);

xStart = 0;
dx = 0.2;
N = 25;
x = xStart + (0:N-1)*dx;

%Plot
h = hist(arrival_times,25);
number_of_hits = size(arrival_times);
figure;
subplot(2,1,1); 
plot(x,h);
title('Subplot 1');

subplot(2,1,2)  
plot(coor);
title('Subplot 2')
number_of_hits;