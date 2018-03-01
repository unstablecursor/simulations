%http://onlinelibrary.wiley.com/doi/10.1111/j.1574-6968.2001.tb10662.x/full
%link for bacteria swimming speed.
%Ill take it 50 micrometers per second.

%Step size. (Seconds).
step = 10^-4;
speed = 40;
time = 5;
cell_radius = 5;
nanobot_coor = [-30, 0, 0];
nanobot_radius = 2;
num_of_molecules = 100000;
std = 10;

molecules = normrnd(0, std, [num_of_molecules, 3]);

scatter3( molecules(:,1) , molecules(:,2) , molecules(:,3) , 0.1 , 'fill' )

distance = zeros(time/step,1);

bias = [0,0,0];

r = normrnd(0, 1, [1 3]);
disp = (speed*step)./sqrt(sum(r.^2, 2)).*r;

hitt_old = 0;

[X,Y,Z] = sphere;
h = figure(1);
axis tight manual;
filename = 'testAnimated.gif';

for i = 1:time/step
       
    nanobot_coor = nanobot_coor + disp;
    hitt = sum((sum((molecules - nanobot_coor).^2, 2) <= nanobot_radius^2));   
    if(hitt > hitt_old)
        bias = (bias * 0.99 +  disp * 0.01 );
        hitt_old = hitt;
    elseif(hitt < hitt_old)
        bias = (bias * 0.99 - disp * 0.01);
        hitt_old = hitt; 
    elseif(hitt == 0)
        bias = [0,0,0]; %%Maybe future work? idk...
        hitt_old = hitt;
    else
        hitt_old = hitt;
    end      
    r = normrnd(0, 1, [1 3]);
    disp = ((speed*step)./sqrt(sum(r.^2 , 2))).*r * 0.5  ...
        + ((speed*step)./sqrt(sum(bias.^2 , 2))).*bias * 0.5; 
    disp(isnan(disp)) = 0;
    distance(i) = sqrt(sum((nanobot_coor).^2, 2));  
    
    if(mod(i, 500) == 1)
        hold on
        mesh(X*5 , Y*5 , Z*5);
        surf(X*0.1 + nanobot_coor(1), Y*0.1 + nanobot_coor(2), Z*0.1 + nanobot_coor(3));
        axis([-40  40   -40  40   -40  40]);
        view(0,90);
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

%plot(arrival_times)