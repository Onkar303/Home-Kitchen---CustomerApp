//
//  CartViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit

class CartViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "CartViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK:- configure UI
    func configureUI(){
        
        self.title = "CART"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
