//
//  OrderStatusViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 21/11/20.
//

import Foundation
import UIKit

class OrderStatusViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "OrderStatusViewController"
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    var isSuccessfull:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    
    //MARK:- Set Data
    func setData(){
        
        if isSuccessfull {
            messageLabel.text = Constants.SUCCESS
            titleImageView.image = UIImage(systemName:"checkmark")
        } else
        {
            messageLabel.text = Constants.ERROR
            titleImageView.image = UIImage(systemName:"checkmark")
        }
    }
    
}
