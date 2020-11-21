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
    
    var category:String?
    var fireStore:Firestore?
    var kitchens = [HomeKitchen]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        attachDelegates()
        configureFirebase()
        fetchKitchenForCategory()
        //fetchKitchens()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(segueToCartViewController))
        
    }
    
    
    //MARK:- Configure FireStore
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    
    //MARK:- Fetching kitchens a particular category
    func fetchKitchenForCategory(){
        kitchens.removeAll()
        fireStore?.collection(Constants.FIRE_STORE_KITCHEN_COLLECTION_NAME).whereField("kitchenCuisine", isEqualTo: category).getDocuments(completion: { (querySnapShot, error) in
            
            if let error = error {
                print("error fetching kitchen according to cuisine \(error)")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            querySnapShot?.documents.forEach({ (queryDocument) in
                do {
                    let jsonSerializaation = try JSONSerialization.data(withJSONObject: queryDocument.data(), options: [])
                    let data = try jsonDecoder.decode(HomeKitchen.self, from: jsonSerializaation)
                    self.kitchens.append(data)
                }catch let error {
                    print("error converting data ")
                }
            })
            
            DispatchQueue.main.async {
                self.kitchenTableView.reloadData()
            }

        })
    }
    
    //MARK:- Fetching kitchens
//    func fetchKitchens(){
//        kitchens.removeAll()
//        fireStore?.collection(Constants.FIRE_STORE_KITCHEN_COLLECTION_NAME).getDocuments(completion: { (querySnapShot, error) in
//            if let error = error {
//                print("error fetchinf kitchens from Firebase \(error)")
//                return
//            }
//            
//            let jsonDecoder = JSONDecoder()
//            querySnapShot?.documents.forEach({ (queryDocument) in
//                do {
//                    let jsonSerialization = try JSONSerialization.data(withJSONObject: queryDocument.data() , options: [])
//                    let data = try jsonDecoder.decode(HomeKitchen.self, from: jsonSerialization)
//                    self.kitchens.append(data)
//                } catch let error{
//                    print("error in adding kitchens \(error)")
//                }
//            })
//            
//            DispatchQueue.main.async {
//                self.kitchenTableView.reloadData()
//            }
//        })
//    }
    
    
    //MARK:- Segue To Dishes View Controller
    func segueToDishesViewController(indexPath:IndexPath){
        let storyBoard = UIStoryboard(name: "DishesStoryboard", bundle: .main)
        let dishesViewController = storyBoard.instantiateViewController(identifier:DishesViewController.STORYBOARD_IDENTIFIER) as! DishesViewController
        dishesViewController.homeKitchen  = kitchens[indexPath.row]
        self.navigationController?.pushViewController(dishesViewController, animated: true)
        
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
    
    func segueToOrderStatusViewContorller(){
        let storyBoard = UIStoryboard(name: "OrderStatusStoryboard", bundle: .main)
        let orderStatusViewController = storyBoard.instantiateViewController(identifier: OrderStatusViewController.STORYBOARD_IDENTIFIER) as! OrderStatusViewController
       navigationController?.pushViewController(orderStatusViewController, animated: true)
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
        segueToDishesViewController(indexPath: indexPath)
    }
    
    
}

//MARK:- Handling search
extension KitchenViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}

extension KitchenViewController:OrderStatusDelegate{
    func showOrderSatus(shouldShow: Bool) {
        if shouldShow {
           segueToOrderStatusViewContorller()
        }
    }
}
