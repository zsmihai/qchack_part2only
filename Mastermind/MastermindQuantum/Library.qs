// this file should be structured like a kata; break the problem into small functions; we can also make a ReferenceImplementation.qs, like in the katas

namespace MastermindQuantum {
    
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arrays;


    operation IncrementCounter(counter : LittleEndian) : Unit is Ctl+Adj
    {
        if (Length(counter!) >= 2)
        {
            Controlled IncrementCounter([counter![0]], LittleEndian(counter![1..Length(counter!)-1]));
        }
        X(counter![0]);
    }

    // Task 1.1: Oracle check if a qubit register is equal to an integer
    operation Task_1_1_CompareWithInteger(
        qubits : LittleEndian,
        integer : Int,
        target : Qubit
    ) : Unit is Adj + Ctl
    {
        ControlledOnInt(integer, X)(qubits!, target);
    }


    // Task 1.2: Oracle check if 2 qubit registers are equal
    operation Task_1_2_CompareRegistersOracle(
        register1: LittleEndian,
        register2: LittleEndian,
        target: Qubit
    ) : Unit is Adj + Ctl
    {
        within {
            ApplyToEachCA(CNOT, Zipped(register1!, register2!));
        } apply {
            // if all XORs are 0, the bit strings are equal.
            ControlledOnInt(0, X)(register2!, target);
        }
    }

    // Task 1.2: Oracle check if 2 qubit registers are equal, increments counter
    operation Task_1_3_CompareRegistersOracle(
        integerToBeCounted : Int,
        register: LittleEndian,
        counter: LittleEndian
    ) : Unit is Adj + Ctl
    {
        ControlledOnInt(integerToBeCounted, IncrementCounter(_))(register!, counter);
    }

    // Task 1.4: Count the number of times a integer is present in an array of qubits
    operation Task_1_4_CountInArray(
        integerToBeCounted : Int,
        registerArray : LittleEndian[],
        counter: LittleEndian
    ) : Unit is Adj + Ctl
    {
        let forEachOperation = Task_1_3_CompareRegistersOracle(integerToBeCounted, _, counter);
        ApplyToEachCA(forEachOperation, registerArray);
    }

    // operation CompareRegisters(registerPair: (LittleEndian, LittleEndian), counter: LittleEndian) : Unit is Adj+Ctl
    // {
    //     Task_1_3_CompareRegistersOracle(Fst(registerPair), Snd(registerPair), counter);
    // }

    // // Task 1.4: Count the number of times a qubit register is present in an array of qubits
    // operation Task_1_5_CountMatchingPairs(
    //     firstArray : LittleEndian[],
    //     secondArray : LittleEndian[],
    //     counter: LittleEndian
    // ) : Unit is Adj + Ctl
    // {
    //     let forEachOperation = CompareRegisters(_, counter);
    //     ApplyToEachCA(forEachOperation, Zipped(firstArray, secondArray));
    // }

    operation Task_1_6_MastermindCheckCondition(
        currentGuess: LittleEndian[],
        conditionValues : Int[],
        target: Qubit
    ) : Unit is Adj+ Ctl
    {
        Message("start");
        let conditionColors = conditionValues[0..3];
        let expectedExactMatches = conditionValues[4];
        let expectedPartialMatches = conditionValues[5];
        use counters = Qubit[6]
        {
            within
            {
                let exactCounter = LittleEndian(counters[0..2]);
                let partialCounter = LittleEndian(counters[3..5]);

                let guessesLength = Length(currentGuess);
                for i in 0 .. guessesLength-1
                {
                    use checkEquality = Qubit()
                    {
                        within
                        {
                            Message($"here {guessesLength}");
                            Task_1_1_CompareWithInteger(currentGuess[i], conditionColors[i], checkEquality);
                        }
                        apply
                        {
                            // if is is an exact match, we count it
                            Controlled (IncrementCounter(_))([checkEquality], exactCounter);

                            // if it is not an exact match, 
                            X(checkEquality);
                            Controlled (Task_1_4_CountInArray(conditionColors[i], currentGuess, _))([checkEquality], partialCounter);
                            X(checkEquality);
                        }
                    }
                }
            }
            apply
            {
                Message("done counting");
                let exactCounter = LittleEndian(counters[0..2]);
                let partialCounter = LittleEndian(counters[3..5]);
                use checkConditionQbits = Qubit[2]
                {
                    within
                    {
                        Task_1_1_CompareWithInteger(exactCounter, expectedExactMatches, checkConditionQbits[0]);
                        Task_1_1_CompareWithInteger(partialCounter, expectedPartialMatches, checkConditionQbits[1]);
                    }
                    apply
                    {
                        
                        Message("done");
                        ControlledOnInt(3, X)(checkConditionQbits, target);
                    }
                }
            }
        }
    }

    operation Task_1_7_MastermindOracle(
        currentGuess: LittleEndian[],
        conditions : Int[][],
        target: Qubit
    ) : Unit is Adj+ Ctl
    {
        use conditionQbits = Qubit[Length(conditions)]
        {
            //let conditionQubitPairs = Zipped(conditions, conditionQbits);
            //ApplyToEachCA((Task_1_6_MastermindCheckCondition(currentGuess, Fst(_), Snd(_))), conditionQubitPairs);
            within
            {
                for i in 0..Length(conditions) - 1
                {
                    Task_1_6_MastermindCheckCondition(currentGuess, conditions[i], conditionQbits[i]);
                }
            }
            apply
            {
                Controlled X(conditionQbits, target);
            }
        }
    }

    operation HelloQ () : Unit {
        Message("Hello quantum world!");
    }

}
