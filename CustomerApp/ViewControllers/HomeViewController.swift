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
    
    @IBOutlet weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        customiseView()
    }
    
    func attachDelegates(){
        
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    func customiseView() {
        self.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func sequeToKitchenViewController(){
        
        let storyBoard = UIStoryboard(name: "KitchenStoryboard", bundle: .main)
        let kitchenViewController = storyBoard.instantiateViewController(identifier:KitchenViewController.STORYBOARD_IDENTIFIER)
        
        self.navigationController?.pushViewController(kitchenViewController, animated: true)
        
    }
    
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.CELL_IDENTIFIER, for: indexPath) as! HomeTableViewCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sequeToKitchenViewController()
    }
    
    
    
}
