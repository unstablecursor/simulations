%Diffusion coefficient(Micrometers^2/seconds).
coef = 79.4;
coef_nanobot = 0.122686537;
%Step size. (Seconds).
step = 10^-3;
%Total time. (Seconds).
time = 1;
std = sqrt(2 * coef * step);
number_of_agents = 10000;
number_of_drugs = 10000;
number_of_nanobots = 5000;
cell_radius = 5;
%Creating normally distributed agent molecules
agents = normrnd(0, 5, [number_of_agents, 3]);
x = agents;
t = cell_radius./sqrt(sum(x.^2, 2));
agents = agents + t.*agents;

min_agent = 1;

%Creating normally distributed drug molecules
drugs = normrnd(0, 5, [number_of_drugs, 3]);
x = drugs;
t = cell_radius./sqrt(sum(x.^2, 2));
drugs = drugs + t.*drugs;

nanobots = normrnd(0, 0.1, [number_of_nanobots, 3]);
x = nanobots;
t = (cell_radius + 2)./sqrt(sum(x.^2, 2));
nanobots = nanobots + t.*nanobots;
count = 0;

nanobot_radius = 1;
arrival_agents = zeros(number_of_nanobots,25);
arrival_times = zeros(number_of_drugs,1);
interval_agent_hit = zeros(number_of_nanobots,1);
interval_drug_hit = zeros(number_of_nanobots,1);
ded_nanos = zeros(number_of_nanobots, 1);

interval = 0.2;

for i = 1:time/step
    %Random movement vector generation.
    drug_movements = normrnd(0,std, size(drugs));
    %agent_movements = normrnd(0,std, size(agents));
    %nano_movements = normrnd(0, sqrt(2 * coef_nanobot * step));
    drugs = drugs + drug_movements;
    %agents = agents + agent_movements;
    %nanobots = nanobots + nano_movements;

    
    hits = (sum(drugs.^2, 2) <= cell_radius^2) & (arrival_times == 0);
    arrival_times(hits) = i*step;
    
    for j = 1:number_of_nanobots
        if(ded_nanos(j) == 0)
            agent_hits = (sum((agents - nanobots(j)).^2, 2) <= nanobot_radius^2);
            drug_hits = (sum((drugs - nanobots(j)).^2, 2) <= nanobot_radius^2);
            interval_agent_hit(j) = interval_agent_hit(j) + sum(agent_hits(:)==1);
            interval_drug_hit(j) = interval_drug_hit(j) + sum(drug_hits(:)==1);
            if(mod(i * step, interval) == 0)
                %Uncomment this for minimum number of agents.
                if(interval_agent_hit(j) > min_agent)
                    if(interval_agent_hit(j) / interval_drug_hit(j) <= 0.4 + mod(j, 5) * 0.1 )
                        x = (number_of_drugs/number_of_nanobots) * (5 - mod(j, 5));
                        drugs = vertcat(drugs, repmat(nanobots(j), x ,3));
                        arrival_times = vertcat(arrival_times, zeros(x ,1));
                        ded_nanos(j) = 1;
                        count = count + 1;
                    end
                    interval_agent_hit(j) = 0;
                    interval_drug_hit(j) = 0;
                end
            end
        end
    end
    if(mod(i * step, interval) == 0)
        count
        size(drugs)
    end

end


arrival_times = arrival_times(arrival_times ~= 0);

xStart = 0;
dx = 0.1;
N = 10;
x = xStart + (0:N-1)*dx;

%Plot
h = hist(arrival_times,10);
number_of_hits = size(arrival_times);
figure;
plot(x,h);
title('Hits');
