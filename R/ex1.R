library(threejs)

z <- seq(-10, 10, 0.01)
x <- cos(z)
y <- sin(z)

scatterplot3js(x, y, z,
               color=rainbow(length(z)))

View(mtcars)
