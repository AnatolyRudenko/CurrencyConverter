//
//  CoinManager.swift
//  CurrencyConverter
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updatePrice(price1: Double, currency1: String, price2: Double, currency2: String)
    func tellTableView(descriptions: [String], symbols: [String])
    func didFailWithError(error: Error)
}

struct CoinManager {

    var delegate: CoinManagerDelegate?
    private let baseURL = K.URL
    
    func getCoinPrice (for currency1: String,_ currency2: String, firstCall: Bool) {

        if let url = URL(string: baseURL) {

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let coinData = self.parseJSON(safeData) {
                                                
                        if firstCall { //информация для tableView
                            var descriptions = [""]
                            
                            let listOfCoins = Array(coinData.keys)
                            let sortedListOfCoins = listOfCoins.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending } //Сортируем символы валют в алфавитном порядке
                            
                            for key in sortedListOfCoins {
                                if let safeCoinData = coinData[key] {
                                    descriptions.append(safeCoinData.Name) //Создаем ряд с соответсвующими сиволам именами
                                }
                            }
                            descriptions.removeFirst()
                            self.delegate?.tellTableView(descriptions: descriptions, symbols: sortedListOfCoins)
                        }
                            
                        if let coinInfo1 = coinData[currency1] { //Собираем курс нужных валют
                            let value1 = coinInfo1.Value
                            if let coinInfo2 = coinData[currency2] {
                                let value2 = coinInfo2.Value
                                self.delegate?.updatePrice(price1: value1, currency1: currency1, price2: value2, currency2: currency2)
                            } else {
                                print("no name matches currency2")
                            }
                        } else {
                            print("no name matches currency1")
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func parseJSON(_ data: Data) -> [String: CoinInfo]? {

        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.Valute

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
