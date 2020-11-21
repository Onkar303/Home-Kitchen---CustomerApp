//
//  Order.swift
//  CustomerApp
//
//  Created by Techlocker on 19/11/20.
//

import Foundation

class Order{
    var customerName:String?
    var customerContactNumber:Int?
    var customerAddress:String?
    var customerId:String?
    var totalAmount:Int?
    var kitchenName:String?
    var kitchenId:String?
    var kitchenOrderReference:String?
    var isOrderCompleted:Bool?
    var dishesToOrder:[DishToOrder]?
    
    
    func converToDictionary() -> [String:Any] {
        var dict = [String:Any]()
        
        dict["customerName"] = customerName
        dict["customerContactNumber"] = customerContactNumber
        dict["customerAddress"] = customerAddress
        dict["customerId"] = customerId
        dict["totalAmount"] = totalAmount
        dict["kitchenName"] = kitchenName
        dict["kitchenId"] = kitchenId
        dict["kitchenOrderReference"] = kitchenOrderReference
        dict["isOrderCompleted"] = isOrderCompleted
        //dict["dishesToOrder"] = dishesToOrder
        return dict
    }
}
