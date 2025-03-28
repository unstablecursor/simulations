function arrival_times = s2s_absorb(num_of_mols, reciever_radius, ...
    reciever_coordinates, transmitter_radius, transmitter_coordinates, ...
    coef, step, time, flow)
%S2S_ABSORB Summary of this function goes here

%Molecule x, y, z coordinate matrix
mol_matrix = zeros(num_of_mols, 3); 
%Arrival times.
arrival_times = zeros(num_of_mols,1);
%Standart deviation of the gaussian diffusion motion.
std = sqrt(2 * coef * step);

%Simulation start.
for i = 1:time/step
    %Random movement vector generation.
    movements = normrnd(0,std, size(mol_matrix));

    %Molecule movementns added to positions.
    mol_matrix = mol_matrix + movements + (flow * step);
    %Calculations for transmitter hits.
    mol_matrix_temp_t = mol_matrix;
    mol_matrix_temp_t = mol_matrix_temp_t - transmitter_coordinates;
    mol_matrix_temp_t = mol_matrix_temp_t.^2;
    sum_vector_t = sum(mol_matrix_temp_t, 2);
    %If Sum of squares is smaller or equal to radius^2, then it is a hit.
    hits_t = (sum_vector_t <= transmitter_radius^2) & (arrival_times == 0);
    %Absorbed molecules gets -1 in arrival times. Then they are dropped in
    %function return.
    arrival_times(hits_t) = -1;
    
    mol_matrix_temp = mol_matrix;
    %Subtract each molecules position from sphere's coordinates.
    mol_matrix_temp = mol_matrix_temp - reciever_coordinates;
    %Square each value
    mol_matrix_temp = mol_matrix_temp.^2;
    %Sum of squares of values.
    sum_vector = sum(mol_matrix_temp, 2);
    %If Sum of squares is smaller or equal to radius^2, then it is a hit.
    hits = (sum_vector <= reciever_radius^2) & (arrival_times == 0);
    %Hits is a logical vector that holds 0 for no-hits, 1 for hits.
    %Store arrival times.
    arrival_times(hits) = i*step;

end

arrival_times = arrival_times(arrival_times ~= 0);
arrival_times = arrival_times(arrival_times ~= -1);

end

