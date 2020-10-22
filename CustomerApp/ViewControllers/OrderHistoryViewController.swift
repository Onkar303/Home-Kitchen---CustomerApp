//
//  OrderHistoryViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit

class OrderHistoryViewController:UIViewController{
    
    @IBOutlet weak var ordersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachSearchController()
        attachDelegates()
        
    }
    
    func attachDelegates(){
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
    }
    
    func attachSearchController(){
        
        self.title = "Orders"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic
    
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
