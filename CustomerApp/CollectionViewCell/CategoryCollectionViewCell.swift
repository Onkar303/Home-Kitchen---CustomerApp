//
//  CategoryCollectionViewCell.swift
//  CustomerApp
//
//  Created by Techlocker on 21/11/20.
//

import Foundation
import UIKit

class CategoryCollectionViewCell:UICollectionViewCell{
    static let CELL_IDENTIFIER = "categoryCell"
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
}
