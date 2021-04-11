---
languages:
- qsharp
- csharp
products:
- qdk
description: "This project uses Grover's search algorithm to solve Mastermind puzzles."

---

# Solving Mastermind using Grover's Algorithm


This program demonstrates solving Mastermind puzzle using Grovers algorithm.
     
The code supports 4 colors 4 slots Mastermind puzzles.
          
For 4 colors 4 slots puzzles, the same rules apply:

- The colors R, G, B, Y may appear more than once
- The maximum black pegs (exact match) is maximum at 4, and win the game if max black pegs reached
- The maximum white pegs (partial match) have no limit
```
     As an example              has solution
     _________________          _________________
     | R | G | B | B |          | R | G | B | B |••••
     -----------------          -----------------
```
Mastermind is a decision problem that given a set of guesses and the number of black and white pegs scored for each guess, is there exist one secret pattern that generate the exact scores.

## Prerequisites ##

- The Microsoft [Quantum Development Kit](https://docs.microsoft.com/azure/quantum/install-overview-qdk/).

## Running the Sample ##

To run the sample, use the `dotnet run` command from your terminal.
This will run all the test puzzles. 
You can also choose a specific puzzle to solve by adding the puzzle name as below
    
-   4s4c : test Quantum algorthm on a 4 colors 4 slots puzzle

For example, `dotnet run 4s4c` will run the Quantum solution for a 4 colors 4 slots puzzle

## Manifest ##

- [XXXGrover.qs](XXXGrover.qs): Q# code implementing XXX
- [Program.cs](Program.cs): C# code with Mastermind test problems to solve using Quantum code. It then checks and displays the results.
- [MastermindQuantum.cs](MastermindQuantum.cs): C# code to solve a Mastermind puzzle by transforming it into a XXX problem (YYY constraints), and call the Quantum SolvePuzzle operation to solve it.
- [host.csproj](host.csproj): Main project.