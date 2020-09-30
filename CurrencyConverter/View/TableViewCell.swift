//
//  TableViewCell.swift
//  CurrencyConverter
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Anatoly Rudenko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none 
    }
}

