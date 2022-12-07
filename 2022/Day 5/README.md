# Notes

## Part 1

To help solve this I wrote a function to dump the layout in the same style shown in the problem which helped to verify that the instructions were carried out properly. Unfortunately I likely spent a majority of the time on that then the logic to actually solve the puzzle. 

## Part 2

Slight modifications to my crate moving function. I tried to get creative in part 1 using a recursive function, but I would have been better off grabbing the whole range like I did in part 2 but in reverse.

For benchmarking both parts I commented out writing the layout since that greatly slows down processing. By getting the whole range to move I cut the time to 33% of part 1, good savings!
