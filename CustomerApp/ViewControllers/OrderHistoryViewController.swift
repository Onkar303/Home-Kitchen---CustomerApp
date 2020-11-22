//
//  OrderHistoryViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class OrderHistoryViewController:UIViewController{
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    var fireStore:Firestore?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFirebase()
        configureUI()
        attachDelegates()
        
    }
    
    
    func attachDelegates(){
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
    }
    
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    func configureUI(){
        
        self.title = "Orders"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(segueToCartViewController))
    
    }
    
    
//    func getOrders(){
//        fireStore?.collectionGroup(<#T##collectionID: String##String#>).where
//    }
    
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
}

extension OrderHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.CELL_IDENTIFIER, for: indexPath) as! OrdersTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(130)
    }
}

extension OrderHistoryViewController:OrderStatusDelegate{
    func showOrderSatus(shouldShow: Bool) {
        if shouldShow {
            segueToOrderStatusViewContorller()
        }
    }
    
    
}
