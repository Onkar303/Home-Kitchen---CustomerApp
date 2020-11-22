//
//  DishToOrder.swift
//  CustomerApp
//
//  Created by Techlocker on 19/11/20.
//

import Foundation

class DishToOrder:Codable{
    var dishId:Int?
    var dishName:String?
    var dishQuantity:Int?
    var dishPrice:Double?
        
    
    func convertToDictionary() -> [String:Any]{
        var dict = [String:Any]()
        dict["dishId"] = dishId
        dict["dishName"] = dishName
        dict["dishQuantity"]  = dishQuantity
        dict["dishPrice"] = dishPrice
        return dict
    }
}
