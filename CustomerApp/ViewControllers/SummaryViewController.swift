//
//  SummaryViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 19/11/20.
//

import Foundation
import UIKit

class SummaryViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "SummaryViewController"
    
    @IBOutlet weak var summaryLabel: UILabel!
    var summaryText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let summaryText = summaryText else {return}
        summaryLabel.text = summaryText
    }
    
    
    
}
