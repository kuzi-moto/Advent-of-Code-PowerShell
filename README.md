# Advent-of-Code-PowerShell

[Advent of Code](https://adventofcode.com/) is series of programming challenges where a new problem is revealed every day for the month of December, until Christmas. I'll be attempting these challenges using PowerShell to improve my skill with it. Though you are able to use any language you want.

## Rules & Organization

* Each day gets its own folder. Each folder will contain:
  * Part 1 & 2 solutions.
  * A README for anything noteworthy.
  * The input file for the day.
  * Runtime stats for both parts.
* Try to do everything on my own, no peeking at other solutions. Googling for general powershell usage allowed.
* Use the `Get-Stats.ps1` script to get the execution time.
* Try to get the execution time within 1-2 seconds.
* All of the scripts can be run without any arguments to grab the default input, or supply a path to the desired file.
* Test my knowledge of Powershell and hopefully learn something new.
* Okay to skip a day if it's not fun or taking too long.

## Helper Scripts

### New-Day.ps1

This script creates a new "day" folder for the current year or a specific year if `-Year` is used. It copies files from the `/templates` folder to provide a basic boilerplate for the next set of puzzles.

### Get-Stats.ps1

This script runs the solution script, and outputs a stats file to measure performance. By default will attempt to run the most recent year and the latest day/part. Assumes the solutions are named `P1.ps1` and `P2.ps1`.

## Status

### 2022

|  Day  |  Part 1  |  Part 2  |
| :---: | :------: | :------: |
|   1   | Complete | Complete |
|   2   | Complete | Complete |
|   3   | Complete | Complete |
|   4   | Complete | Complete |
|   5   | Complete | Complete |
|   6   | Complete | Complete |
|   7   | Complete | Complete |
|   8   | Complete | Complete |
|   9   | Complete | Complete |

### 2021

|  Day  |  Part 1  |  Part 2  |
| :---: | :------: | :------: |
|   1   | Complete | Complete |

### 2020

|  Day  |  Part 1  |  Part 2  |
| :---: | :------: | :------: |
|   1   | Complete | Complete |
|   2   | Complete | Complete |
|   3   |          |          |

### 2019

|  Day  |   Part 1    |  Part 2  |
| :---: | :---------: | :------: |
|   1   |  Complete   | Complete |
|   2   |  Complete   | Complete |
|   3   |  Complete   | Complete |
|   4   |  Complete   | Complete |
|   5   |  Complete   | Complete |
|   6   |  Complete   | Complete |
|   7   | In-Progress |          |

### 2018

|  Day  |   Part 1    |  Part 2  |
| :---: | :---------: | :------: |
|   1   |  Complete   | Complete |
|   2   |  Complete   | Complete |
|   3   |  Complete   | Complete |
|   4   |  Complete   | Complete |
|   5   |  Complete   | Complete |
|   6   |  Complete   | Complete |
|   7   | In-Progress |          |

## Others

* https://github.com/charlieschmidt/AdventOfCode2018
* https://github.com/SotoDucani/AdventOfCode2018
* https://github.com/ThePSAdmin/AdventOfCode/tree/master/2018/PowerShell
* https://github.com/kib/aoc2018
* https://github.com/rdameron/adventofcode
* https://github.com/VortexUK/AdventOfCode/tree/master/2018
