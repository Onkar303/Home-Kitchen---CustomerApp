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
        
    }
    
    
    //MARK:- Fetching All dishes from firebase
    func fetchAllDishes(){
        kitchenDishes.removeAll()
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
}

//MARK:- Handling Collection View
extension DishesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kitchenDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier:DishesTableViewCell.CELL_IDENTIFIER, for: indexPath) as! DishesTableViewCell
        
        cell.dishNameLabel.text = kitchenDishes[indexPath.row].title
        Utilities.loadImage(url:kitchenDishes[indexPath.row].image, imageView: cell.dishImageView)
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
        print(searchController.searchBar.text)
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
