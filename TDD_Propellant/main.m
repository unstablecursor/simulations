%http://onlinelibrary.wiley.com/doi/10.1111/j.1574-6968.2001.tb10662.x/full
%link for bacteria swimming speed.
%Ill take it 40 micrometers per second.

%Diffusion coefficient(Micrometers^2/seconds).
coef = 15;
%Step size. (Seconds).
step = 10^-4;
std = sqrt(2 * coef * step);
speed = 30;
time = 4;
cell_radius = 5;

num_of_molecules = 80000;
molecules = zeros(num_of_molecules, 3);
is_released = false(num_of_molecules, 1);

nanobot_coor = [15, 0, 0];
nanobot_radius = 3;

arrival_times = zeros(20000,1);
nano_hit_memory = 0;
bias = [0,0,0];
q = normrnd(0, 0.001, [1, 3]);
x = (speed*step)./sqrt(sum(q.^2, 2)).*q;
old_hitt = 0;
count = 0;
intervall = 100;

for i = 1:time/step
    
    is_released(2*i-1:2*i, :) = true;
    
    q = normrnd(0, 0.001, [2, 3]);
    molecules(2*i-1:2*i, :) = cell_radius./sqrt(sum(q.^2, 2)).*q;
    
    %Random movement vector generation.
    movement = normrnd(0, std, size(molecules(is_released, :)));
    %Molecule movements added to positions.
    molecules(is_released, :) = molecules(is_released, :) + movement;
    %Rollback operation.
    hits_r = (sum(molecules(is_released, :).^2, 2) < cell_radius^2);
    t = molecules(is_released, :);
    t(hits_r, :) = t(hits_r, :) - movement(hits_r, :);
    molecules(is_released, :) = t;
       
    if(i > (time/step)/2)
        nanobot_coor = nanobot_coor + x;
        hitt = sum((sum((molecules - nanobot_coor).^2, 2) <= nanobot_radius^2));   
        if(hitt > old_hitt)
            bias = bias + x;
            old_hitt = hitt;
        elseif(hitt < old_hitt)
            bias = bias - x;
            old_hitt = hitt;    
        else
            old_hitt = hitt;
        end     
        x = (speed*step)./sqrt(sum(bias.^2 , 2)).*bias; 
        arrival_times(i - (time/step)/2) = sum((nanobot_coor).^2, 2); 
    end  
     
end

plot(arrival_times)
