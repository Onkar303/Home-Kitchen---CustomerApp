//
//  AddToCartViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit

class AddToCartViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "AddToCartViewController"
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var readyInMinutesLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var vegeterianLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var dishInformation:DishInformation?
    var homeKitchen:HomeKitchen?
    var dishAddedResponseDelegate:DishAddResponseDelegate?
    var totalAmount:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setData()
        addTapGesture()
        setValue()
    }
    
    
    
    //MARK:- Configure UI
    func configureUI(){
        //self.navigationController?.navigationBar.isHidden = true
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(segueToCartViewController))
//
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(segueToCartViewController))
    }
    
    //MARK:- Set Value for quantity
    func setValue(){
        if isDishToOrderPresent()
        {
            quantityLabel.text = String((getDishToOrderifPresent()?.dishQuantity)!)
            stepper.value = Double((getDishToOrderifPresent()?.dishQuantity)!)
            
            let totalAmount = stepper.value * 10
            totalAmountLabel.text = "$\(totalAmount)"
        }
    }
    
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segueToSummaryController))
        summaryLabel.addGestureRecognizer(tapGesture)
        summaryLabel.isUserInteractionEnabled = true
    }
    
    //MARK:- Set data
    func setData(){
        guard let dishInformation = dishInformation else {return}
        dishNameLabel.text = dishInformation.title
        summaryLabel.text = Utilities.removeHtmlTags(text:dishInformation.summary)
        servingLabel.text = String(dishInformation.servings ?? 0)
        readyInMinutesLabel.text = String(dishInformation.readyInMinutes ?? 0) + " Minutes"
        healthScoreLabel.text = String(dishInformation.healthScore ?? 0)
        vegeterianLabel.text = dishInformation.vegetarian! ? "YES" : "NO"
        Utilities.loadImage(url:dishInformation.image , imageView: dishImageView)
    }
    
 
    //MARK:- Segue To Summary Controller
    @objc func segueToSummaryController(){
        let storyboard = UIStoryboard(name:"SummaryStoryboard", bundle: .main)
        let summaryController = storyboard.instantiateViewController(identifier: SummaryViewController.STORYBOARD_IDENTIFIER) as! SummaryViewController
        summaryController.summaryText = summaryLabel.text
        present(summaryController, animated: true, completion: nil)
       
    }
    
    
    //MARK:- Segue to CartView Controller
    @objc func segueToCartViewController(){
        
        if Utilities.dishesToOrder.count != 0 {
            let storyboard = UIStoryboard(name:"CartStoryboard", bundle: .main)
            let cartViewController = storyboard.instantiateViewController(identifier: CartViewController.STORYBOARD_IDENTIFIER) as! CartViewController
            cartViewController.orderStatusDelegate = self
            self.present(cartViewController, animated: true, completion: nil)
        }else {
            present(Utilities.showMessage(title: "Alert!", message:"Cart Empty !"), animated: true, completion: nil)
        }
        
    }
    
    func segueToOrderStatusViewContorller(){
        let storyBoard = UIStoryboard(name: "OrderStatusStoryboard", bundle: .main)
        let orderStatusViewController = storyBoard.instantiateViewController(identifier: OrderStatusViewController.STORYBOARD_IDENTIFIER) as! OrderStatusViewController
       navigationController?.pushViewController(orderStatusViewController, animated: true)
    }
    
    
    
    //MARK:- Asking for Cart change
    func askForCartChange(didConfirm: @escaping (Bool)->Void){
        let alertController = UIAlertController(title: "Alert!", message: "An Order from a different kitchen Exists. If you wish to add a new Order please select confirm", preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            self.removeOrder()
            didConfirm(true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(actionConfirm)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Remove Order
    func removeOrder(){
        Utilities.dishesToOrder.removeAll()
        Utilities.order.kitchenId = nil
        Utilities.order.kitchenName = nil
        Utilities.order.customerName = nil
        Utilities.order.customerContactNumber = nil
        Utilities.order.customerAddress = nil
        Utilities.order.totalAmount = nil
        Utilities.order.dishesToOrder = nil
    }

    //MARK:- Handling Add to Cart button action 
    @IBAction func addToCart(_ sender: Any) {
        if Utilities.checkForSameOrder(homeKitchen: homeKitchen!){
            addDishToOrder()
        } else {
            if Utilities.order.kitchenId == nil {
                setOrder()
                addDishToOrder()
            } else {
                askForCartChange { (didConfirm) in
                    if didConfirm {
                        self.setOrder()
                        self.addDishToOrder()
                    }
                }
            }
        }
    }
    
    //MARK:- Adding Dish to Order
    func addDishToOrder(){
        Utilities.addDishToOrdersList(dishToOrder: createDishToOrder()) { [self] (didAdd, dish) in
            if didAdd {
                self.navigationController?.popViewController(animated: true)
                self.dishAddedResponseDelegate?.dishAddedOrUpdated(didAdd: didAdd,didUpdate: false)
            } else {
                dish?.dishQuantity = Int(quantityLabel.text!)
                self.navigationController?.popViewController(animated: true)
                self.dishAddedResponseDelegate?.dishAddedOrUpdated(didAdd: didAdd,didUpdate: true)
            }
        }
        
    }
    
    //MARK:- set Order
    func setOrder(){
        Utilities.order.kitchenId = homeKitchen?.kitchenID
        Utilities.order.kitchenName = homeKitchen?.kitchenName
        Utilities.order.kitchenOrderReference = homeKitchen?.kitchenOrdersCollectionReference
        
    }
    
    
    // MARK:- GET DIshToOrder idf present
    func getDishToOrderifPresent() -> DishToOrder?{
        var returnDish:DishToOrder?
        Utilities.dishesToOrder.forEach { (dish) in
            if dish.dishId == dishInformation?.id {
                returnDish = dish
            }
        }
        return returnDish
    }
    
    
    //MARK:-  Check if DishToOrder is present
    func isDishToOrderPresent() -> Bool {
        var isPresent = false
        Utilities.dishesToOrder.forEach { (dish) in
            if dish.dishId == dishInformation?.id {
                isPresent = true
            }
        }
        return isPresent
    }
    
    
    //MARK:- Creating DishToOrder
    func createDishToOrder() -> DishToOrder?{
        if Int(quantityLabel.text!) == 0 {
            present(Utilities.showMessage(title: "Alert!", message:"Please increase the quantity by 1"), animated: true, completion: nil)
            return nil
        } else {
            let dishToOrder = DishToOrder()
            dishToOrder.dishId = dishInformation?.id
            dishToOrder.dishName = dishInformation?.title
            dishToOrder.dishQuantity = Int(quantityLabel.text!) ?? 0
            dishToOrder.dishPrice = 10
            return dishToOrder
        }
    }
    
    //MARK:- Handling Stepper
    @IBAction func chnageQuantity(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
        totalAmount = sender.value * 10
        totalAmountLabel.text = "$\(totalAmount!)"
    }
}


extension AddToCartViewController:OrderStatusDelegate {
    func showOrderSatus(shouldShow: Bool) {
        if shouldShow {
            segueToOrderStatusViewContorller()
        }
    }
    
    
}


