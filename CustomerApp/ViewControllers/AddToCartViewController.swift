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
    var dishInformation:DishInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setData()
        addTapGesture()
    }
    
    
    //MARK:- Configure UI
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
    
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
    
 
    @objc func segueToSummaryController(){
        let storyboard = UIStoryboard(name:"SummaryStoryboard", bundle: .main)
        let summaryController = storyboard.instantiateViewController(identifier: SummaryViewController.STORYBOARD_IDENTIFIER) as! SummaryViewController
        
        summaryController.summaryText = summaryLabel.text
        
        present(summaryController, animated: true, completion: nil)
       
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let dishToOrder = DishToOrder()
        dishToOrder.dishId = dishInformation?.id
        dishToOrder.dishName = dishInformation?.title
        dishToOrder.dishQuantity = Int(quantityLabel.text!) ?? 0
        dishToOrder.dishPrice = Int(totalAmountLabel.text!) ?? 0
        
        if dishToOrder.dishQuantity == 0 {
            present(Utilities.showMessage(title: "Alert!", message:"Please increase the quantity by 1"), animated: true, completion: nil)
            return
        }
        
        Utilities.dishToOrder.append(dishToOrder)
        self.dismiss(animated: true, completion: nil)
        
    
    }
    
    @IBAction func chnageQuantity(_ sender: UIStepper) {
        quantityLabel.text = String(sender.value)
        totalAmountLabel.text = "$\(sender.value*10)"
    }
    
    
}
