//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//


import UIKit
class MainViewController: UIViewController {
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var coinManager = CoinManager()
    private var tableViewDescriptions = [""]
    private var tableViewSymbols = [""]
    private var leftCoin = "USD"
    private var rightCoin = "EUR"
    private var convertionProportion = 1.00
    private var left: Bool?
    
    private var leftValue = 1.00
    private var multiplyer = 1.00
    //leftValue, multiplyer введены для того, чтобы число слева сохраняло свое значение при смене валют, до тех пор пока юзер не решит его изменить
    
    
        override func viewDidLoad() {
           super.viewDidLoad()
            title = K.title.mainViewController
            stackView.isHidden = true
            
            coinManager.delegate = self
            coinManager.getCoinPrice(for: leftCoin, rightCoin, firstCall: true) //Конвертируем заранее выбранные валюты, чтобы экран не был пустым после запуска
            
            leftTextField.addTarget(self, action: #selector(leftTextFieldDidChange), for: .editingChanged)
            rightTextField.addTarget(self, action: #selector(rightTextFieldDidChange), for: .editingChanged) //отслеживам изменения в TextField
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap) //прячем клавиатуру при тапе вне клавиатуры
        }
    
    @IBAction func changeCurrencyPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            left = true
        } else {
            left = false
        }
        performSegue(withIdentifier: K.segue.toCurrencyTableViewController, sender: nil)
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == K.segue.toCurrencyTableViewController {
        
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! CurrencyTableViewController
            svc.coinsList = tableViewSymbols
            svc.coinsDescription = tableViewDescriptions //Сообщаем  destinationVC необходимые данные
            svc.coinManager = coinManager //это необходимо для корректного вызова метода CoinManager из destinationVC
            svc.leftCoin = leftCoin.self
            svc.rightCoin = rightCoin.self //Говорим, какие монеты находятся на экране в данный момент
            
            if let isItLeft = left.self {
                svc.left = isItLeft //говорим, какую валюту надо поменять
            }
            if let stringLeftValueBefore = leftTextField.text {
                if let leftValueBefore = Double(stringLeftValueBefore) {
                    leftValue = leftValueBefore //это для упомянутого в начале сохранения левого числа
                }
            }
        }
    }
    
    private func convert(_ value1: Double, _ value2: Double) {
        if leftValue == 1 {
            self.leftTextField.text = String(Int(leftValue))
            self.rightTextField.text = String(format: "%.2f", self.convertionProportion) //на начальном экране показыаем курс выбранных заранее валют в формате: 1 <-> х
        } else {
            self.leftTextField.text = String(format: "%.2f", multiplyer / self.convertionProportion)
            self.rightTextField.text = String(format: "%.2f", multiplyer) //последующие конвертации после смены валюты
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func leftTextFieldDidChange() {
        if let text = leftTextField.text {
            if let value = Double(text) {
                self.rightTextField.text = String(format: "%.2f", value * self.convertionProportion)
                return
            }
        }
        self.rightTextField.text = ""
    }
    
    @objc func rightTextFieldDidChange() {
        if let text = rightTextField.text {
            if let value = Double(text) {
                self.leftTextField.text = String(format: "%.2f", value / self.convertionProportion)
                return
            }
        }
            self.leftTextField.text = ""
    } //Конвертация в реальном времени
}

        
//MARK: - CoinManagerDeleagate

extension MainViewController: CoinManagerDelegate {
    func tellTableView(descriptions: [String], symbols: [String]) {
        tableViewDescriptions = descriptions
        tableViewSymbols = symbols //при запуске программы получаем информацию для заполнения tableView, после уже не вызываем эту функцию и обновляем только курс валют
    }
    
    
    func updatePrice(price1: Double, currency1: String, price2: Double, currency2: String) {
        DispatchQueue.main.async {
            self.leftCoin = currency1
            self.rightCoin = currency2
            self.leftLabel.text = self.leftCoin
            self.rightLabel.text = self.rightCoin
            
            self.convertionProportion = price1 / price2
            self.multiplyer = price1 / price2 * self.leftValue
            self.convert(self.multiplyer, price2)
            
            self.loadingView.isHidden = true
            self.stackView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
    print(error)
    }
}
