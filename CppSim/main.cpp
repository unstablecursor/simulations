#include <iostream>
#include <random>
#include <math.h>

#define NUMBER_OF_MOLECULES 10000

#define COEF 79.4
#define STEP 0.0001
#define TIME 2
//Instead of calculation std every time, I've
//put calculated std
#define STD 0.1260

const unsigned int seed = time(0);
std::mt19937_64 rng(seed);
std::normal_distribution<float> norm(0, STD);

#define R_RADIUS 5
#define R_X 10
#define R_Y 0
#define R_Z 0


void molecule_sim(float &x, float &y, float &z, float &arrival){
    x = norm(rng);
    y = norm(rng);
    z = norm(rng);
    for (int i = 1; i < int(TIME / STEP); ++i) {
        x += norm(rng);
        y += norm(rng);
        z += norm(rng);
        if(pow(x - R_X, 2) + pow(y - R_Y, 2) + pow(z - R_Z, 2) <= (R_RADIUS * R_RADIUS)){
            arrival = i;
            return;
        }
    }
    arrival = -1;
    return;
}


int main() {
    float *x_coor = new float[NUMBER_OF_MOLECULES];
    float *y_coor = new float[NUMBER_OF_MOLECULES];
    float *z_coor = new float[NUMBER_OF_MOLECULES];

    float *arrival_times = new float[NUMBER_OF_MOLECULES];

    for (int i = 0; i < NUMBER_OF_MOLECULES; ++i) {
        molecule_sim(x_coor[i], y_coor[i], z_coor[i], arrival_times[i]);
    }
    int count = 0;
    for (int i = 0; i < NUMBER_OF_MOLECULES; ++i) {
        if(arrival_times[i] > 0){
            count++;
        }
    }
    std::cout << count;
    return 0;
}