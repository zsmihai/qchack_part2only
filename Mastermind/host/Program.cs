using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static System.Diagnostics.Debug;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

//
// This file will contain inputs for the demo
//

namespace MastermindQuantum
{
    static class Program
    {
        /// <summary>
        /// Main entry point.
        /// </summary>
        /// <param name="args">
        /// <para>Add the following argument to specify which puzzles to run:</para>
        /// <list type="bullet">
        /// <item><description>`all` or blank : run all puzzles (default)</description></item>
        /// <item><description>`4s4c` : test classic algorthm on a 4slot-4colors puzzle</description></item>
        /// </list>
        /// </param>
        static async Task Main(string[] args)
        {
            using var sim = new QuantumSimulator();

            var restored = await HelloQ.Run(sim);

            //MAIN            
            var puzzleToRun = args.Length > 0 ? args[0] : "all";

            //var sim = new QuantumSimulator(throwOnReleasingQubitsNotInZeroState: true);

            //MastermindClassic mMastermindClassic = new MastermindClassic();
            //MastermindQuantum mastermindQuantum = new MastermindQuantum();

            if (puzzleToRun == "4s4c" || puzzleToRun == "all") 
            {
                // Test solving a 4x4 Mastermind puzzle using XXX computing.
                // Missing numbers are denoted by 0.
                int[] answer4 = { 2,3,4,1 };
                int[] color4 = { 1,2,3,4 };
                int[] puzzle4 = { 0,0,0,0 };
                Console.WriteLine("Solving 4slot-4colors using XXX computing.");
                ShowGrid(puzzle4);
                bool resultFound = false;
                //bool resultFound = mastermindClassic.SolveMastermindClassic(puzzle4, color4);
                //bool resultFound = mastermindQuantum.QuantumSolve(puzzle4, color4, sim).Result;
                VerifyAndShowResult(resultFound, puzzle4, answer4);
            }

            Console.WriteLine("Finished.");
        }

        
        /// <summary>
        /// If result was found, verify it is correct (matches the answer) and show it
        /// </summary>
        /// <param name="resultFound">True if a result was found for the puzzle</param>
        /// <param name="puzzle">The puzzle to verify</param>
        /// <param name="answer">The correct puzzle result</param>
        static void VerifyAndShowResult(bool resultFound, int[] puzzle, int[] answer) 
        {
            if (!resultFound) 
                Console.WriteLine("No solution found.");
            else 
            {
                bool good = puzzle.Cast<int>().SequenceEqual(answer.Cast<int>());
                if (good)
                    Console.WriteLine("Result verified correct.");
                ShowGrid(puzzle);
            }
            Pause();
        }

        /// <summary>
        /// Copy an Int 2 dimensional array
        /// </summary>
        /// <param name="org">The array to copy</param>
        /// <returns>A copy of the array</returns>
        static int[] CopyIntArray(int[] org)
        {
            int size = org.GetLength(0);
            int[] result = new int[size];
            for (int i = 0; i < size; i++)
                result[i] = org[i];
            return result;
        }

        /// <summary>
        /// Display the puzzle
        /// </summary>
        static void ShowGrid(int[] puzzle)
        {
            int size = puzzle.GetLength(0);
            for (int i = 0; i < 1; i++)
            {
                Console.WriteLine(new String('-', 4 * size + 1));
                for (int j = 0; j < size; j++)
                {
                    if (puzzle[i] == 0)
                        Console.Write("| X ");
                    else
                        Console.Write($"| {puzzle[i], 1} ");
                }
                Console.WriteLine("|");
            }
            Console.WriteLine(new String('-', 4 * size + 1));
        }

        /// <summary>
        /// Pause execution with a message and wait for a key to be pressed to continue.
        /// </summary>
        static void Pause()
        {
            System.Console.WriteLine("\n\nPress any key to continue...\n\n");
            System.Console.ReadKey();
        }
    }
}