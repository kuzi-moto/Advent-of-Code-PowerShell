# Notes

## Part 1

When looking at the test case, I was going to generate maps for each of the different categories containing the full range of values possible. When looking at the actual puzzle input I realized that would not be feasible since each one would contain millions of values. The maps instead saved the minimum and maximum for each range and if the source number is contained within the range calculate the offset from the minimum value to calculate the destination value. Loop through all the maps using the previous destination as the source for the next one.

## Part 2
