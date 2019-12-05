# Notes

## Part 1

I tried to use some .net classes, like System.Drawing.Drawing2D to do the actual calculation of intersections, but it doesn't work well with just line segments. In the end I just did some simple calculations since all lines were either horizontal or vertical. I commented out some code to try to visualize the shapes of the wires in a windows form, but it only worked on my test input. Perhaps the values are too large in the real input. Some of the lines went into negative values on the coordinate grid, so to show on the form properly they needed to be shifted up and to the right.

## Part 2

