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
    @IBOutlet weak var dishesCollectionView: UICollectionView!
    var homeKitchen:HomeKitchen?
    var kitchenDishes = [DishInformation]()
    var fireStore:Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        attachDelegate()
        configureFirebase()
        fetchAllDishes()
    }
    
    //MARK:- Attach Delegate
    func attachDelegate(){
        dishesCollectionView.delegate = self
        dishesCollectionView.dataSource = self
    }
    
    //MARK:- Configure Firebase
    func configureFirebase(){
        fireStore = Firestore.firestore()
        
    }
    
    //MARK:- Configure UI
    func configureUI(){
        self.title = "dishes"
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.obscuresBackgroundDuringPresentation = false
//
//        self.navigationItem.searchController = searchController
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        

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
                self.dishesCollectionView.reloadData()
            }
        })
        
        
    }
}

//MARK:- Handling Collection View
extension DishesViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kitchenDishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:DishesCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as! DishesCollectionViewCell
        
        cell.dishNameLabel.text = kitchenDishes[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width*0.95
        let height = view.frame.height * 0.4
        
        return CGSize(width: width , height: height)
    }
    
    
}
