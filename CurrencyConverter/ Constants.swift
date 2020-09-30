//
//   Constants.swift
//  CurrencyConverter
//
//  Created by Admin on 19.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//

import Foundation

struct K {
     
    static let URL = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    struct title {
         static let mainViewController = "Конвертер валют"
         static let currencyTableViewController = "Выбор валют"
    }
    struct segue {
        static let toCurrencyTableViewController = "toCurrencyList"
    }
}
