//
//  DishesViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit

class DishesViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "DishesViewController"
    @IBOutlet weak var DishesCollectionView: DishesCollectionViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Attach Delegate 
    func attachDelegate(){
        
    }
    
    
}
