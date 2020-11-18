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
    var kitchens = [HomeKitchen]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
        attachDelegates()
        configureFirebase()
        fetchKitchens()
    }
    
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        kitchenTableView.delegate = self
        kitchenTableView.dataSource = self
    }
    
    //MARK:- Confgiuring the UI
    func configureUI(){
        
        self.title = "Kitchen"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    
    //MARK:- Configure FireStore
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Fetching kitchens
    func fetchKitchens(){
        kitchens.removeAll()
        fireStore?.collection(Constants.FIRE_STORE_KITCHEN_COLLECTION_NAME).getDocuments(completion: { (querySnapShot, error) in
            if let error = error {
                print("error fetchinf kitchens from Firebase \(error)")
                return
            }
           
            let jsonDecoder = JSONDecoder()
            querySnapShot?.documents.forEach({ (queryDocument) in
                do {
                    let jsonSerialization = try JSONSerialization.data(withJSONObject: queryDocument.data() , options: [])
                    let data = try jsonDecoder.decode(HomeKitchen.self, from: jsonSerialization)
                    self.kitchens.append(data)
                } catch let error{
                    print("error in adding kitchens \(error)")
                }
            })
            
            DispatchQueue.main.async {
                self.kitchenTableView.reloadData()
            }
        })
    }
    
    
    //MARK:- Segue To Dishes View Controller
    func segueToDishesViewController(){
        let storyBoard = UIStoryboard(name: "DishesStoryboard", bundle: .main)
        let dishesViewController = storyBoard.instantiateViewController(identifier:DishesViewController.STORYBOARD_IDENTIFIER) as! DishesViewController
        self.navigationController?.pushViewController(dishesViewController, animated: true)
        
    }
    
}

//MARK:- Handling TableView
extension KitchenViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kitchens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KitchenTableViewCell.CELL_IDENTIFIER, for: indexPath) as! KitchenTableViewCell
        cell.kitchenNameLabel.text = kitchens[indexPath.row].kitchenName
        cell.imageView?.setRounded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToDishesViewController()
    }
    
    
}

//MARK:- Handling search
extension KitchenViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}
