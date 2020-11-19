//
//  CartTableViewCell.swift
//  CustomerApp
//
//  Created by Techlocker on 19/11/20.
//

import Foundation
import UIKit

class CartTableViewCell:UITableViewCell{
    static let CELL_IDENITIFIER = "CartTableViewCell"
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var quantityNameLabel: UILabel!
    @IBOutlet weak var amountNameLabel: UILabel!
    
}
