//
//  HomeKitchen.swift
//  CustomerApp
//
//  Created by Techlocker on 18/11/20.
//

import Foundation
class HomeKitchen:NSObject,Decodable {
    
    
    var kitchenName:String?
    var kitchenAddress:String?
    var kitchenOwner:String?
    var kitchenContactNumber:String?
    var foodHandlingCertificate:String?
    var foodAndHygineCertificate:String?
    var kitchenID:String?
    var kitchenDishesCollectionReference:String?
    var kitchenOrdersCollectionReference:String?
    var kitchenImageURL:String?
    var kitchenCuisine:String?
    
    
    enum Keys:String,CodingKey {
        case kitchenName
        case kitchenAddress
        case kitchenOwner
        case kitchenContactNumber
        case foodHandlingCertificate
        case foodAndHygineCertificate
        case kitchenID
        case kitchenDishesCollectionReference
        case kitchenOrdersCollectionReference
        case kitchenImageURL
        case kitchenCuisine
    }
    
    
    
    func convertToDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["kitchenName"] = kitchenName
        dictionary["kitchenAddress"] = kitchenAddress
        dictionary["kitchenOwner"] = kitchenOwner
        dictionary["kitchenContactNumber"] = kitchenContactNumber
        dictionary["foodHandlingCertificate"] = foodHandlingCertificate
        dictionary["foodAndHygineCertificate"] = foodAndHygineCertificate
        dictionary["kitchenID"] = kitchenID
        dictionary["kitchenDishesCollectionReference"] = kitchenDishesCollectionReference
        dictionary["kitchenOrdersCollectionReference"] = kitchenOrdersCollectionReference
        dictionary["kitchenImageURL"] = kitchenImageURL
        dictionary["kitchenCuisine"] = kitchenCuisine
        return dictionary
    }
}
