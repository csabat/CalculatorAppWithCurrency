//
//  Operation.swift
//  Calculator
//
//  Created by admin on 20/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

enum OperationType {
    case modification((Double) -> Double)
    case operation((Double,Double) -> Double)
    case reset
    case equal
}


