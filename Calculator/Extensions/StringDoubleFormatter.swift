//
//  StringDoubleFormatter.swift
//  Calculator
//
//  Created by admin on 21/10/2017.
//  Copyright © 2017 admin. All rights reserved.


import Foundation

extension String {

    func doubleFormatter() -> String {
        //Remove the floating point and the zero in case the results ending with them.
        var array = [Character]()
        for c in self {
            array.append(c)
        }
        if array[array.count - 1] == "0" && array[array.count - 2] == "." {
            print(array)
            array.remove(at: array.count - 1)
            print(array)
            array.remove(at: array.count - 1)
            print(array)
            return String(array)
        }
        return String(array)
    }
    

    
}



