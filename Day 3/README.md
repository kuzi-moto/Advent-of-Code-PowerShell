# Notes

## Part 1

* This one took me a little while, also I'm pretty sure there is a much better way of doing this as the run time is just silly. I didn't bother measuring but it's at least 10+ minutes. Hey but at least it does get it right!

## Part 2

* I found System.Drawing.Rectangle and was able to really simplify the code required to check if two claims are intersecting.
* There could also be an application for System.Drawing.Region which may be able to reduce the runtime of Part 1. I may go back and try that out at some point.
* I should be able to test if they overlap, and if they do, create a region that contains the overlapping areas. There then should be a way to determine the area of the resulting region.