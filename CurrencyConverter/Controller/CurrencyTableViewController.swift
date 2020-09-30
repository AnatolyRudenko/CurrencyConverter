//
//  CurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    var coinsList: [String]?
    var coinsDescription: [String]?
    var left: Bool = false
    var leftCoin: String?
    var rightCoin: String?
    private var chosenIndex = 0
    var coinManager: CoinManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.title.currencyTableViewController
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        if let coinToGet = coinsList?[chosenIndex],
            let coinManager = self.coinManager,
            let leftCoin = self.leftCoin,
            let rightCoin = self.rightCoin {
            if left {
                coinManager.getCoinPrice(for: coinToGet, rightCoin, firstCall: false)
            } else {
                coinManager.getCoinPrice(for: leftCoin, coinToGet, firstCall: false)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.nameLabel.text = coinsDescription?[indexPath.item]
        cell.symbolLabel.text = coinsList?[indexPath.item]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndex = indexPath.item //ловим индекс желаемой валюты
    }
}

