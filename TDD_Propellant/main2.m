%http://onlinelibrary.wiley.com/doi/10.1111/j.1574-6968.2001.tb10662.x/full
%link for bacteria swimming speed.
%Ill take it 40 micrometers per second.

%Diffusion coefficient(Micrometers^2/seconds).
coef = 79.4;
%Step size. (Seconds).
step = 10^-4;
std = sqrt(2 * coef * step);
speed = 40;
time = 5;
cell_radius = 5;

num_of_molecules = 40000;

molecules = normrnd(0, 10, [num_of_molecules, 3]);
x = molecules;
t = cell_radius./sqrt(sum(x.^2, 2));
molecules = molecules + t.*molecules;

%molecules = zeros(num_of_molecules, 3);
%is_released = false(num_of_molecules, 1);

nanobot_coor = [-25, 0, 0];
nanobot_radius = 2;

arrival_times = zeros(20000,1);
nano_hit_memory = 0;
bias = [0,0,0];
q = normrnd(0, 0.001, [1, 3]);
x = (speed*step)./sqrt(sum(q.^2, 2)).*q;
old_hitt = 0;
count = 0;
intervall = 100;

[X,Y,Z] = sphere;
h = figure(1);
axis tight manual;
filename = 'testAnimated.gif';

for i = 1:time/step
       
    nanobot_coor = nanobot_coor + x;
    hitt = sum((sum((molecules - nanobot_coor).^2, 2) <= nanobot_radius^2));   
    if(hitt > old_hitt)
        bias = (bias + x);
        old_hitt = hitt;
    elseif(hitt < old_hitt)
        bias = (bias - x);
        old_hitt = hitt; 
    elseif(hitt == 0)
        bias = -bias;
        old_hitt = hitt;
    else
        old_hitt = hitt;
    end      
    q = normrnd(0, 0.001, [1, 3]);
    x = (speed*step)./sqrt(sum((q + bias / 10).^2 , 2)).*(bias /10 + q); 
    arrival_times(i) = sum((nanobot_coor).^2, 2);  
    
    if(mod(i, 200) == 1)
        %hold on
        %mesh(X*5 , Y*5 , Z*5);
        surf(X*1 + nanobot_coor(1), Y*1 + nanobot_coor(2), Z*1 + nanobot_coor(3));
        axis([-30  30   -30  30   -30  30]);
        axis square;
        refreshdata;
        drawnow;
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        if i == 1 
             imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append');
        end 
    end
end

plot(arrival_times)
