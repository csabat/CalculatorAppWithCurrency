//
//  Constants.swift
//  Calculator
//
//  Created by admin on 21/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

//Mathematical Operation Symbols

let MULTIPLY = "X"
let DIVIDE = "/"
let ADD = "+"
let SUBSTRACT = "-"
let EQUAL = "="

//Modifiers

let PLUSMINUS = "+/-"
let PERCENT = "%"

//AC
let AC = "AC"

//EQUAL

let EQUALSIGN = "="

//DataService

var BASE_URL = "http://api.fixer.io/latest"
var rates = "rates"

//Notification

let RATE_READY = Notification.Name("RateBeenUpdated")
let ERROR_FETCHING_RATES = Notification.Name("NoDataAvailable")

