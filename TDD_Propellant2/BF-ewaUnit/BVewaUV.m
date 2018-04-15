%Step size. (Seconds).
step = 10^-4;
speed = 40;
time = 5;
cell_radius = 5;
nanobots = [0, 0, 0];

%%%VARIABLES TO CHANGE%%%
number_of_nanobots = 10; %%NUMBER OF NANOBOTS TO SIMULATE
nanobots(:,1) = -25; %%DISTANCE
nanobot_radius = 2;  %%RADIUS OF THE NANOBOT
num_of_molecules = 40000; %%NUMBER OF MOLECULES
std = 10;  %%STANDART DEVIATION OF THE MOLECULE DISTRIBUTION
%%%VARIABLES TO CHANGE%%%

distances = zeros(number_of_nanobots, 1);

for j = 1:number_of_nanobots
    molecules = normrnd(0, std, [num_of_molecules, 3]);
    nanobot = nanobots;
    bias = [0,0,0];
    r = normrnd(0, 1, [1 3]);
    disp = (speed*step)./sqrt(sum(r.^2, 2)).*r;
    hitt_old = 0;
    hitt = 0;
    r = normrnd(0, 1, [1 3]);
    for i = 1:time/step
        nanobot = nanobot + disp;
        hitt = sum((sum((molecules - nanobot).^2, 2) <= nanobot_radius^2));   
        if(hitt > hitt_old)
            bias = (bias * 0.99 +  disp * 0.01 );
            hitt_old = hitt;
        elseif(hitt < hitt_old)
            bias = (bias * 0.99 - disp * 0.01);
            hitt_old = hitt; 
        elseif(hitt == 0)
            bias = [0,0,0]; % idk...
            hitt_old = hitt;
        else
            hitt_old = hitt;
        end      
        r = normrnd(0, 1, [1 3]);  
        r_unit = r / sqrt(sum(r.^2, 2));
        bias_unit = bias / sqrt(sum(bias.^2 ,2));
        bias_unit(isnan(bias_unit)) = 0;
        r_unit(isnan(r_unit)) = 0;
        disp = ((bias_unit + r_unit)*(speed*step))/2 ; 
        disp(isnan(disp)) = 0;
    end
    distances(j) = sqrt(sum((nanobot).^2, 2)); 
end

hist(distances)