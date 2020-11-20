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
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var topHandleView: UIView!
    
    
    var dishesToOrder = Utilities.dishesToOrder
    var homeKitchen:HomeKitchen?
    var orderActions = ["Confirm Order","Cancel Order"]
    
    let TITLE_SECTION = 0
    let DISHES_SECTION = 1
    let TOTAL_SECTION = 2
    let ACTION_SECTION_CONFIRM = 3
    let ACTION_SECTION_CANCEL = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        attachDelegates()
    }
    
    //MARK:- configure UI
    func configureUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        topHandleView.clipsToBounds = true
        topHandleView.layer.cornerRadius = topHandleView.frame.width/10
        
    }
    
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }
    
    //MARK:- Caluculating the Total
    func calculateTotal() -> Double{
        var total:Double = 0
        dishesToOrder.forEach({ (dishToOrder) in
            total = total + (Double(dishToOrder.dishQuantity!)*dishToOrder.dishPrice!)
        })
        return total
    }
    
    //MARK:-
    func segueToOrderStatusViewContorller(){
        
    }
    
}




//MARK:- Handling Table View
extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == DISHES_SECTION {
            return dishesToOrder.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == TITLE_SECTION {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: CartTitleTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CartTitleTableViewCell
            titleCell.kitchenNameLabel.text = "Kitchen:\(homeKitchen?.kitchenName)"
            return titleCell
        }
        
        if indexPath.section == DISHES_SECTION{
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.CELL_IDENITIFIER, for: indexPath) as! CartTableViewCell
            cell.amountNameLabel.text = "$\(Double(dishesToOrder[indexPath.row].dishQuantity!) *  dishesToOrder[indexPath.row].dishPrice!)"
            cell.quantityNameLabel.text = String(dishesToOrder[indexPath.row].dishQuantity!) + " X"
            cell.dishNameLabel.text = dishesToOrder[indexPath.row].dishName
            return cell
        }
        
        if indexPath.section == TOTAL_SECTION {
            let totalCell = tableView.dequeueReusableCell(withIdentifier: CartTotalTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CartTotalTableViewCell
            totalCell.totalLabel.text  = "$\(calculateTotal())"
            return totalCell
        }
        
        if indexPath.section == ACTION_SECTION_CONFIRM {
            let actionCellConfirm = tableView.dequeueReusableCell(withIdentifier: CartOrderActionTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CartOrderActionTableViewCell
            
            actionCellConfirm.cartActionLabel.text = "Confirm"
            actionCellConfirm.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            actionCellConfirm.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return actionCellConfirm
        }
        
        let actionCellCancel = tableView.dequeueReusableCell(withIdentifier: CartOrderActionTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CartOrderActionTableViewCell
        
        actionCellCancel.cartActionLabel.text = "Cancel"
        actionCellCancel.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        actionCellCancel.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return actionCellCancel
        
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if indexPath.section == DISHES_SECTION {
    //            return CGFloat(85)
    //        }
    //        return 44
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == ACTION_SECTION_CONFIRM {
            
        }
        
        if indexPath.section == ACTION_SECTION_CANCEL {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == DISHES_SECTION {
            return "Dish To Order"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, indexPath.section == DISHES_SECTION {
            dishesToOrder.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath], with: .left)
            cartTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == DISHES_SECTION {
            return .delete
        } else {
            return .none
        }
    }
    
    
    
}
