//
//  DishesCollectionViewCell.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit

class DishesTableViewCell:UITableViewCell{
    static let CELL_IDENTIFIER = "dishesCell"
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
}
