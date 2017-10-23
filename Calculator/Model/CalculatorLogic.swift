//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by admin on 21/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    private var value: Double?
    private var operations: Dictionary<String, OperationType> = [
        ADD : OperationType.operation({$0 + $1}),
        MULTIPLY : OperationType.operation({$0 * $1}),
        DIVIDE : OperationType.operation({$0 / $1}),
        SUBSTRACT : OperationType.operation({$0 - $1}),
        PLUSMINUS : OperationType.modification(changeSign),
        PERCENT : OperationType.modification(percentOf),
        AC : OperationType.reset,
        EQUAL: OperationType.equal
    ]
    
    private var pendingOperation: PendingOperation?
    
    private struct PendingOperation {
        var firstNumber : Double
        var symbol : (Double,Double) -> Double
        
        func performResult(secondNumber: Double) -> Double {
            return symbol(firstNumber,secondNumber)
        }
    }
    
    private mutating func performResultWithSecondNumber() {
        guard let value = value else {return}
        self.value = pendingOperation?.performResult(secondNumber: value)
        pendingOperation = nil
    }
    
    mutating func performResult(_ symbol: String) {
        guard let mathematicalSymbol = operations[symbol] else { return }
        switch mathematicalSymbol {
        case .operation(let function):
            guard let value = value else {return}
            if let pendingOperation = pendingOperation {
                self.value = pendingOperation.performResult(secondNumber: value)
                self.pendingOperation = nil
                self.pendingOperation = PendingOperation(firstNumber: self.value!, symbol: function)
                
            } else {
                pendingOperation = PendingOperation(firstNumber: value, symbol: function)
            }
        case .modification(let function):
            if value != nil {
                self.value = function(value!)
            }
        case .reset:
            reset()
        case .equal:
            performResultWithSecondNumber()
        }
    }
    
    func getValue() -> Double {
        guard let value = value else {
            return 0
        }
        return value
        
    }
    
    mutating func setValue(newValue: Double) {
        self.value = newValue
    }
    
    mutating func reset() {
        value = nil
        pendingOperation = nil
    }
    
}

func changeSign(_ number: Double) -> Double {
    if number == 0 {
        return 0
    } else {
        return -number
    }
}

func percentOf(_ number: Double) -> Double {
    return number / 100
}





