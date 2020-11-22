//
//  HomeViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit

class HomeViewController:UIViewController{
    
    static let CONTROLLER_IDENTIFIER = "HomeViewController"
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    let categories = Constants.SPPONOCULAR_CUISINE_CATEGORY
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        customiseView()
        configureUI()
    }
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    //MARK:- Changing The View
    func customiseView() {
        self.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    
    func configureUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(segueToCartViewController))
    }
    
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
    
    //MARK:- Seqgue To KitchenViewController
    func sequeToKitchenViewController(indexPath:IndexPath){
        let storyBoard = UIStoryboard(name: "KitchenStoryboard", bundle: .main)
        let kitchenViewController = storyBoard.instantiateViewController(identifier:KitchenViewController.STORYBOARD_IDENTIFIER) as! KitchenViewController
        kitchenViewController.category = categories[indexPath.row]
        self.navigationController?.pushViewController(kitchenViewController, animated: true)
    }
    
    func segueToOrderStatusViewContorller(){
        let storyBoard = UIStoryboard(name: "OrderStatusStoryboard", bundle: .main)
        let orderStatusViewController = storyBoard.instantiateViewController(identifier: OrderStatusViewController.STORYBOARD_IDENTIFIER) as! OrderStatusViewController
       navigationController?.pushViewController(orderStatusViewController, animated: true)
    }
}


//MARK:- Handling Table View
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.9
        let height = view.frame.height*0.3
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sequeToKitchenViewController(indexPath: indexPath)
    }
}

extension HomeViewController: OrderStatusDelegate {
    func showOrderSatus(shouldShow: Bool) {
        if shouldShow {
            segueToOrderStatusViewContorller()
        }
    }
}
