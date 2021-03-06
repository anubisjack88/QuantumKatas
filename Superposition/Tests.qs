// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.Superposition {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    
    
    // ------------------------------------------------------
    operation AssertEqualOnZeroState (N : Int, testImpl : (Qubit[] => Unit), refImpl : (Qubit[] => Unit : Adjoint)) : Unit {
        using (qs = Qubit[N]) {
            // apply operation that needs to be tested
            testImpl(qs);
            
            // apply adjoint reference operation and check that the result is |0⟩
            Adjoint refImpl(qs);
            
            // assert that all qubits end up in |0⟩ state
            AssertAllZero(qs);
        }
    }
    
    
    // ------------------------------------------------------
    operation T01_PlusState_Test () : Unit {
        AssertEqualOnZeroState(1, PlusState, PlusState_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T02_MinusState_Test () : Unit {
        AssertEqualOnZeroState(1, MinusState, MinusState_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T03_UnequalSuperposition_Test () : Unit {
        // cross-test
        AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.0), ApplyToEachA(I, _));
        AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.5 * PI()), ApplyToEachA(X, _));
        AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.5 * PI()), ApplyToEachA(Y, _));
        AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.25 * PI()), PlusState_Reference);
        AssertEqualOnZeroState(1, UnequalSuperposition(_, 0.75 * PI()), MinusState_Reference);
        
        for (i in 1 .. 36) {
            let alpha = ((2.0 * PI()) * ToDouble(i)) / 36.0;
            AssertEqualOnZeroState(1, UnequalSuperposition(_, alpha), UnequalSuperposition_Reference(_, alpha));
        }
    }
    
    
    // ------------------------------------------------------
    operation T04_AllBasisVectors_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectors_TwoQubits, AllBasisVectors_TwoQubits_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T05_AllBasisVectorsWithPhases_TwoQubits_Test () : Unit {
        // We only check for 2 qubits.
        AssertEqualOnZeroState(2, AllBasisVectorsWithPhases_TwoQubits, AllBasisVectorsWithPhases_TwoQubits_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T06_BellState_Test () : Unit {
        AssertEqualOnZeroState(2, BellState, BellState_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T07_AllBellStates_Test () : Unit {
        for (i in 0 .. 3) {
            AssertEqualOnZeroState(2, AllBellStates(_, i), AllBellStates_Reference(_, i));
        }
    }
    
    
    // ------------------------------------------------------
    operation T08_GHZ_State_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, GHZ_State, PlusState_Reference);
        
        // for N = 2 it's Bell state
        AssertEqualOnZeroState(2, GHZ_State, BellState_Reference);
        
        for (n in 3 .. 9) {
            AssertEqualOnZeroState(n, GHZ_State, GHZ_State_Reference);
        }
    }
    
    
    // ------------------------------------------------------
    operation T09_AllBasisVectorsSuperposition_Test () : Unit {
        // for N = 1 it's just |+⟩
        AssertEqualOnZeroState(1, AllBasisVectorsSuperposition, PlusState_Reference);
        
        for (n in 2 .. 9) {
            AssertEqualOnZeroState(n, AllBasisVectorsSuperposition, AllBasisVectorsSuperposition_Reference);
        }
    }
    
    
    // ------------------------------------------------------
    operation T10_ThreeStates_TwoQubits_Test () : Unit {
        AssertEqualOnZeroState(2, ThreeStates_TwoQubits, ThreeStates_TwoQubits_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T11_ZeroAndBitstringSuperposition_Test () : Unit {
        // compare with results of previous operations
        AssertEqualOnZeroState(1, ZeroAndBitstringSuperposition(_, [true]), PlusState_Reference);
        AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, [true, true]), BellState_Reference);
        AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, [true, true, true]), GHZ_State_Reference);
        
        mutable b = [true, false];
        AssertEqualOnZeroState(2, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b));
        
        set b = [true, false, true];
        AssertEqualOnZeroState(3, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b));

        set b = [true, false, true, true, false, false];
        AssertEqualOnZeroState(6, ZeroAndBitstringSuperposition(_, b), ZeroAndBitstringSuperposition_Reference(_, b));
    }
    
    
    // ------------------------------------------------------
    operation T12_TwoBitstringSuperposition_Test () : Unit {
        // compare with results of previous operations
        AssertEqualOnZeroState(1, TwoBitstringSuperposition(_, [true], [false]), PlusState_Reference);
        AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, [false, false], [true, true]), BellState_Reference);
        AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, [true, true, true], [false, false, false]), GHZ_State_Reference);
        
        // compare with reference implementation
        // diff in first position
        mutable b1 = [false, true];
        mutable b2 = [true, false];
        AssertEqualOnZeroState(2, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2));

        set b1 = [true, true, false];
        set b2 = [false, true, true];
        AssertEqualOnZeroState(3, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2));
        
        // diff in last position
        set b1 = [false, true, true, false];
        set b2 = [false, true, true, true];
        AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2));
        
        // diff in the middle
        set b1 = [true, false, false, false];
        set b2 = [true, false, true, true];
        AssertEqualOnZeroState(4, TwoBitstringSuperposition(_, b1, b2), TwoBitstringSuperposition_Reference(_, b1, b2));
    }
    
    
    // ------------------------------------------------------
    operation T13_FourBitstringSuperposition_Test () : Unit {
        
        // cross-tests
        mutable bits = [[false, false], [false, true], [true, false], [true, true]];
        AssertEqualOnZeroState(2, FourBitstringSuperposition(_, bits), ApplyToEachA(H, _));
        set bits = [[false, false, false, true], [false, false, true, false], [false, true, false, false], [true, false, false, false]];
        AssertEqualOnZeroState(4, FourBitstringSuperposition(_, bits), WState_Arbitrary_Reference);
        
        // random tests
        for (N in 3 .. 10) {
            // generate 4 distinct numbers corresponding to the bit strings
            mutable numbers = new Int[4];
            
            repeat {
                mutable ok = true;
                for (i in 0 .. 3) {
                    set numbers[i] = RandomInt(1 <<< N);
                    for (j in 0 .. i - 1) {
                        if (numbers[i] == numbers[j]) {
                            set ok = false;
                        }
                    }
                }
            }
            until (ok)
            fixup { }
            
            // convert numbers to bit strings
            for (i in 0 .. 3) {
                set bits[i] = BoolArrFromPositiveInt(numbers[i], N);
            }
            
            AssertEqualOnZeroState(N, FourBitstringSuperposition(_, bits), FourBitstringSuperposition_Reference(_, bits));
        }
    }
    
    
    // ------------------------------------------------------
    operation T14_WState_PowerOfTwo_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        using (qs = Qubit[1]) {
            WState_PowerOfTwo(qs);
            Assert([PauliZ], qs, One, "");
            X(qs[0]);
        }
        
        AssertEqualOnZeroState(2, WState_PowerOfTwo, TwoBitstringSuperposition_Reference(_, [false, true], [true, false]));
        AssertEqualOnZeroState(4, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
        AssertEqualOnZeroState(8, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
        AssertEqualOnZeroState(16, WState_PowerOfTwo, WState_PowerOfTwo_Reference);
    }
    
    
    // ------------------------------------------------------
    operation T15_WState_Arbitrary_Test () : Unit {
        // separate check for N = 1 (return must be |1⟩)
        using (qs = Qubit[1]) {
            WState_Arbitrary_Reference(qs);
            Assert([PauliZ], qs, One, "");
            X(qs[0]);
        }
        
        // cross-tests
        AssertEqualOnZeroState(2, WState_Arbitrary, TwoBitstringSuperposition_Reference(_, [false, true], [true, false]));
        AssertEqualOnZeroState(2, WState_Arbitrary, WState_PowerOfTwo_Reference);
        AssertEqualOnZeroState(4, WState_Arbitrary, WState_PowerOfTwo_Reference);
        AssertEqualOnZeroState(8, WState_Arbitrary, WState_PowerOfTwo_Reference);
        AssertEqualOnZeroState(16, WState_Arbitrary, WState_PowerOfTwo_Reference);
        
        for (i in 2 .. 16) {
            AssertEqualOnZeroState(i, WState_Arbitrary, WState_Arbitrary_Reference);
        }
    }
    
}
