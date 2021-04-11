namespace Tests {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
    // we should write tests here for the implementation in MastermindQuantum library

    @Test("QuantumSimulator")
    operation SimpleTest () : Unit {
        use target = Qubit() 
        {
            use currentGuess = Qubit[8]
            {
                within
                {
                    X(currentGuess[0]);
                    X(currentGuess[2]);
                }
                apply
                {
                    let registers = Chunks(2, currentGuess);
                    let regLEs = Mapped(LittleEndian(_), registers);
                    MastermindQuantum.Task_1_7_MastermindOracle(
                        regLEs,
                        [[1, 0, 1, 2, 1, 4]],
                        target
                    );
                }
                AssertMeasurement([PauliZ], [target], One, "Oracle replied with False when it should have said True.");
                Reset(target);
                ResetAll(currentGuess);
            }
        }
        
        Message("Test passed.");
    }
}