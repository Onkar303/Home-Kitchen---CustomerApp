//
//  AccountDetailsViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit


class AccountDetailsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var accountDetailsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDelegate()
    }
    
    func attachDelegate(){
        
        accountDetailsTableView.delegate = self
        accountDetailsTableView.dataSource = self
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
    }
    
    
    
    }
