//
//  CartViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class CartViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "CartViewController"
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var topHandleView: UIView!
    
    
    var fireStore:Firestore?
    var dishesToOrder = Utilities.dishesToOrder
    var homeKitchen:HomeKitchen?
    var orderStatusDelegate:OrderStatusDelegate?
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
        configureFirebase()
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
    
    //MARK:- Configure FireStore
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Caluculating the Total
    func calculateTotal() -> Double{
        var total:Double = 0
        dishesToOrder.forEach({ (dishToOrder) in
            total = total + (Double(dishToOrder.dishQuantity!)*dishToOrder.dishPrice!)
        })
        return total
    }
    
    //MARK:- going to Order status View Controller
    func segueToOrderStatusViewContorller(){
        let storyBoard = UIStoryboard(name: "OrderStatusStoryboard", bundle: .main)
        let orderStatusViewController = storyBoard.instantiateViewController(identifier: OrderStatusViewController.STORYBOARD_IDENTIFIER) as! OrderStatusViewController
       navigationController?.pushViewController(orderStatusViewController, animated: true)
    }
    
    //MARK:- removing Order
    func removeOrder(){
        Utilities.dishesToOrder.removeAll()
        Utilities.order.kitchenId = nil
        Utilities.order.kitchenName = nil
        Utilities.order.customerName = nil
        Utilities.order.customerContactNumber = nil
        Utilities.order.customerAddress = nil
        Utilities.order.totalAmount = nil
        Utilities.order.dishToOrder = nil
    }
    
    //MARK:- Adding Order To FireStore
    func addToOrderCollection(isSuccessful: @escaping (Bool) -> Void){
        guard let kitchenOrderReference = Utilities.order.kitchenOrderReference else {return}
        guard let order = createOrder() else {return}
        
        fireStore?.collection(kitchenOrderReference).document(order.orderId!).setData(order.converToDictionary(), completion: { (error) in
            if let error = error {
                print("Error placing order \(error)")
                isSuccessful(false)
                return
            }
            self.removeOrder()
            isSuccessful(true)
        })
    }
    

    //MARK:- Creating an Order
    func createOrder() -> Order?{
        Utilities.order.dishToOrder = Utilities.dishesToOrder
        guard let customerFirstName = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_FIRSTNAME) else {  return nil}
        guard let customerLastName = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_LASTNAME) else {  return nil}
        guard let customerCustomerId = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_CUSTOMERID)else {return nil}
        guard let customerAddress = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_CUSTOMERADDRESS) else {return nil}
        guard let customerPhoneNumber = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_CUSTOMERCONTACTNUMBER) else {  return nil}
        let documentReference = Utilities.MD5(string:String(Date().timeIntervalSince1970))
        Utilities.order.orderId = documentReference
        Utilities.order.customerId = customerCustomerId
        Utilities.order.customerName = customerFirstName + " " + customerLastName
        Utilities.order.customerAddress = customerAddress
        Utilities.order.customerContactNumber = Int(customerPhoneNumber)
        Utilities.order.isOrderCompleted = false
        return Utilities.order
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
            if let kitchenName = Utilities.order.kitchenName {
                titleCell.kitchenNameLabel.text = "Kitchen: \(kitchenName)"
            } else {
                titleCell.kitchenNameLabel.text = ""
            }
            
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
            addToOrderCollection { (isSuccessfull) in
                if isSuccessfull {
                    self.dismiss(animated: true) {
                        self.orderStatusDelegate?.showOrderSatus(shouldShow: true)
                    }
                }
            }
        }
        
        if indexPath.section == ACTION_SECTION_CANCEL {
           removeOrder()
           dismiss(animated: true, completion: nil)
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
