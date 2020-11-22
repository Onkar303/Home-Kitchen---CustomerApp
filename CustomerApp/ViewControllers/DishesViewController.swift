//
//  DishesViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class DishesViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "DishesViewController"
    @IBOutlet weak var dishesTableView: UITableView!
    var homeKitchen:HomeKitchen?
    var kitchenDishes = [DishInformation]()
    var filteredKitchenDishes = [DishInformation]()
    var fireStore:Firestore?
    var itemsPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        attachDelegate()
        configureFirebase()
        fetchAllDishes()
    }
    
    //MARK:- Attach Delegate
    func attachDelegate(){
        dishesTableView.delegate = self
        dishesTableView.dataSource = self
    }
    
    //MARK:- Configure Firebase
    func configureFirebase(){
        fireStore = Firestore.firestore()
        
    }
    
    //MARK:- Configure UI
    func configureUI(){
        self.title = "Dishes"
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(segueToCartViewController))
        
    }
    
    
    //MARK:- Fetching All dishes from firebase
    func fetchAllDishes(){
        kitchenDishes.removeAll()
        filteredKitchenDishes.removeAll()
        guard let collectionID = homeKitchen?.kitchenDishesCollectionReference else {return}
        fireStore?.collection(collectionID).getDocuments(completion: { (querySnapShot, error) in
            
            if let error = error {
                print("error fetching dishes \(error)")
                return
            }
            let jsonDecoder = JSONDecoder()
            querySnapShot?.documents.forEach({ (queryData) in
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: queryData.data(), options: [])
                    let dishInformation = try jsonDecoder.decode(DishInformation.self, from: jsonData)
                    self.kitchenDishes.append(dishInformation)
                    self.filteredKitchenDishes.append(dishInformation)
                }catch {
                    print("error adding dishes to array")
                }
            })
            
            DispatchQueue.main.async {
                self.dishesTableView.reloadData()
            }
        })
    }
    
    
    
    //MARK:- Add to cart view controller
    func segueAddToCartViewcontroller(indexPath:IndexPath){
        let storyboard = UIStoryboard(name:"AddToCartStoryboard", bundle: .main)
        let addToCartViewController = storyboard.instantiateViewController(identifier: AddToCartViewController.STORYBOARD_IDENTIFIER) as! AddToCartViewController
        addToCartViewController.dishInformation = kitchenDishes[indexPath.row]
        addToCartViewController.homeKitchen = homeKitchen
        addToCartViewController.dishAddedResponseDelegate = self
        self.navigationController?.pushViewController(addToCartViewController, animated: true)
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
    
    func segueToOrderStatusViewContorller(isSuccessfull:Bool){
        let storyBoard = UIStoryboard(name: "OrderStatusStoryboard", bundle: .main)
        let orderStatusViewController = storyBoard.instantiateViewController(identifier: OrderStatusViewController.STORYBOARD_IDENTIFIER) as! OrderStatusViewController
        
        orderStatusViewController.isSuccessfull = isSuccessfull
       navigationController?.pushViewController(orderStatusViewController, animated: true)
    }
}

//MARK:- Handling Collection View
extension DishesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredKitchenDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier:DishesTableViewCell.CELL_IDENTIFIER, for: indexPath) as! DishesTableViewCell
        
        cell.dishNameLabel.text = filteredKitchenDishes[indexPath.row].title
        Utilities.loadImage(url:filteredKitchenDishes[indexPath.row].image, imageView: cell.dishImageView)
        cell.dishImageView.setRounded()
        cell.priceLabel.text = "$10"
    
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueAddToCartViewcontroller(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = view.frame.height/4
//        return CGFloat(height)
//        
//    }

}

extension DishesViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filteredKitchenDishes.removeAll()
        if text.isEmpty {
            filteredKitchenDishes.append(contentsOf: kitchenDishes)
        } else {
            filteredKitchenDishes = kitchenDishes.filter({ (dish) -> Bool in
                guard let title = dish.title else {return false}
                if title.contains(text){
                    return true
                }
                return false
            })
        }
        dishesTableView.reloadData()
    }
}

extension DishesViewController:DishAddResponseDelegate{
    func dishAddedOrUpdated(didAdd: Bool, didUpdate: Bool) {
        if didAdd {
            present(Utilities.showMessage(title: "Success!", message:"Dish Added To Cart !"), animated: true, completion: nil)
        }
        if didUpdate {
            present(Utilities.showMessage(title: "Success!", message:"Dish Updated !"), animated: true, completion: nil)
        }
    }
}

extension DishesViewController:OrderStatusDelegate{
    func showOrderSatus(shouldShow: Bool,isSuccessfull: Bool) {
        if shouldShow {
           segueToOrderStatusViewContorller(isSuccessfull: isSuccessfull)
        }
    }
}
