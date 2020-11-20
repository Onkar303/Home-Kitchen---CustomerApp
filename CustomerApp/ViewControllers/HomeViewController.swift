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
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    let categories = Constants.SPPONOCULAR_CUISINE_CATEGORY
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        customiseView()
    }
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    //MARK:- Changing The View
    func customiseView() {
        self.title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    //MARK:- Seqgue To KitchenViewController
    func sequeToKitchenViewController(){
        let storyBoard = UIStoryboard(name: "KitchenStoryboard", bundle: .main)
        let kitchenViewController = storyBoard.instantiateViewController(identifier:KitchenViewController.STORYBOARD_IDENTIFIER)
        self.navigationController?.pushViewController(kitchenViewController, animated: true)
    }
}


//MARK:- Handling Table View
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width*0.9
        let height = view.frame.height*0.4
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sequeToKitchenViewController()
    }
    
    
    
}
