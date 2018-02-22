[X,Y,Z] = sphere;

figure(1)
for k1 = 1:100
    surf(X+k1, Y+k1, Z+k1)
    axis([-5  5    -5  5    -5  5])
    axis square
    view([-20  20])
    refreshdata
    drawnow
end