//
//  DataService.swift
//  Calculator
//
//  Created by admin on 21/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

//Resoponsible for web calls and provide an array with keys
class DataService {
    
    static let instance = DataService()
    
    private var keysArray = ["RON", "MYR", "CAD", "DKK", "GBP", "PHP", "CZK", "PLN", "RUB", "SGD", "BRL", "JPY", "SEK", "USD", "HRK", "NZD", "HKD", "BGN", "TRY", "MXN", "HUF", "KRW", "NOK", "INR", "ILS", "IDR", "CHF", "THB", "CNY", "ZAR", "AUD", "EUR"]
    
    func getKeysArray() -> [String] {
        return keysArray
    }
    
    var actualRate : Double? {
        didSet {
            NotificationCenter.default.post(name: RATE_READY, object: nil)
        }
    }
    
    func fetchDataFromServer(calcKey: String, addedKey: String) {
        guard let url = URL(string: BASE_URL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let rawJson = try? JSONSerialization.jsonObject(with: data)
                guard let json = rawJson as? [String: AnyObject] else { return }
                if let rates = json[rates] as? [String: Any] {
                    var calCurrency: Double
                    var addedCurrency: Double
                    if calcKey == "EUR" {
                        calCurrency = 1
                    } else {
                        calCurrency = rates[calcKey] as! Double
                    }
                    if addedKey == "EUR" {
                        addedCurrency = 1
                    } else {
                        addedCurrency = rates[addedKey] as! Double
                    }
                    self.actualRate = addedCurrency / calCurrency
                }
            } else {
                NotificationCenter.default.post(name: ERROR_FETCHING_RATES, object: nil)
            }
        }
        task.resume()
    }
}
