%Number of molecules.
num_of_mols = 10000;
%Distance between release point and reciever(Micrometers).
distance = 10;
transmitter_radius = 5;
transmitter_coordinates = [-transmitter_radius, 0, 0];
%Radius of the spherical reciever(Micrometers).
reciever_radius = 5;
reciever_coordinates = [distance, 0, 0];
%Diffusion coefficient(Micrometers^2/seconds).
coef = 79.4;
%Step size. (Seconds).
step = 10^-4;
%Total time. (Seconds).
time = 2;
%In micrometers per second

flow = [0, 0, 0];
%res = p2s(num_of_mols, reciever_radius, ...
%    reciever_coordinates, coef, step, time, flow);

%flow = [10, 0, 0];

%res = s2s_absorb(num_of_mols, reciever_radius, ...
%    reciever_coordinates, transmitter_radius ,transmitter_coordinates, ...
%    coef, step, time, flow);

%flow = [10, 0, 0];
res = s2s_rollback(num_of_mols, reciever_radius, ...
    reciever_coordinates, transmitter_radius ,transmitter_coordinates, ...
    coef, step, time, flow);

xStart = 0;
dx = 0.01;
N = 200;
x = xStart + (0:N-1)*dx;

%Plot
h = hist(res,200);
number_of_hits = size(res);
plot(x,h);
number_of_hits