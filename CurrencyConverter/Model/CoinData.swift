//
//  CoinData.swift
//  CurrencyConverter
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let Valute: [String: CoinInfo]
}

struct CoinInfo: Decodable {
    let Name: String
    let Value: Double
}

