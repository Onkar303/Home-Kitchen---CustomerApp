//
//  KitchenScreenViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit
import FirebaseFirestore



class KitchenViewController:UIViewController{

    static let STORYBOARD_IDENTIFIER = "KitchenViewController"
    
    @IBOutlet weak var kitchenTableView: UITableView!
    var fireStore:Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        configureUI()
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        kitchenTableView.delegate = self
        kitchenTableView.dataSource = self
    }
    
    //MARK:- Confgiuring the UI
    func configureUI(){

    }
    
    
    //MARK:- Configure FireStore
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Fetching kitchens
    func fetchKitchens(){
        
    }
    
}

extension KitchenViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KitchenTableViewCell.CELL_IDENTIFIER, for: indexPath) as! KitchenTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    
}
