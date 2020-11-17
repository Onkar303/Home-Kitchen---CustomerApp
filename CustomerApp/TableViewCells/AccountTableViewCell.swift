//
//  AccountTableViewCell.swift
//  CustomerApp
//
//  Created by user173285 on 11/16/20.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var accountDetailsLabel: UILabel!
    @IBOutlet weak var accountDetailsValue: UILabel!
    static let CELL_IDENTIFIER = "accountCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
