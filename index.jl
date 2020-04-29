using ForwardDiff
using Makie
using StatsMakie

f(x,y) = -5*x*y*exp(-x^2-y^2)
x = -1:0.1:1.0
y = -1:0.1:1.0
z = [f(i,j) for i in x, j in y]

scene = surface(x,y,z)
xm, ym, zm = minimum(scene_limits(scene))
contour!(scene, x, y, z, levels = 15, linewidth = 2, transformation = (:xy, zm))
wireframe!(scene, x, y, z, overdraw = true, transparency = true, color = (:black, 0.1))
center!(scene) # center the Scene on the display


xy = [(i,j) for i in x for j in y]
# This is the same function as above, just modified so that it will work with ForwardDiff
g(x,y) = [-5*x*y*exp(-x^2-y^2)]
# Jacobians are scaled by 0.05 so that the vector arrows aren't too long when plotted
J = .05 .* [ForwardDiff.jacobian(x -> g(x[1], x[2]), [i[1],i[2]]) for i in xy]
# All the x coordinates
xs = [xy[i][1] for i in 1:7:length(xy)]
# All the y coordinates
ys = [xy[i][2] for i in 1:7:length(xy)]
# We need u,v for the quiver plot
u = [J[i][1] for i in 1:7:length(J)]
v = [J[i][2] for i in 1:7:length(J)]