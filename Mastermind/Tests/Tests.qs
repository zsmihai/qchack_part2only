namespace Tests {
    
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    // we should write tests here for the implementation in MastermindQuantum library

    @Test("QuantumSimulator")
    operation AllocateQubit () : Unit {
        
        using (q = Qubit()) {
            Assert([PauliZ], [q], Zero, "Newly allocated qubit must be in |0> state.");
        }
        
        Message("Test passed.");
    }
}