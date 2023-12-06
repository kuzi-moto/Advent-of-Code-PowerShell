# Notes

## Part 1

This was actually pretty fun. We run through each line and match on any number with `Select-String`. Then check the rows above and below the number, and the columns next to it and check for any non `.` symbols, sum the resulting numbers.

## Part 2

Some slight modifications to P1 needed. Created a reference table to store any numbers which contain an asterisk. For each asterisk in the table with exactly two values multiply them and sum the numbers.
