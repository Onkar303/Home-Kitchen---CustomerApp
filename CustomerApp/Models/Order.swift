//
//  Order.swift
//  CustomerApp
//
//  Created by Techlocker on 19/11/20.
//

import Foundation

class Order:Codable{
    var orderId:String?
    var customerName:String?
    var customerContactNumber:Int?
    var customerAddress:String?
    var customerId:String?
    var totalAmount:Int?
    var kitchenName:String?
    var kitchenId:String?
    var kitchenOrderReference:String?
    var isOrderCompleted:Bool?
    var dishToOrder:[DishToOrder]?
    
    
    func converToDictionary() -> [String:Any] {
        var dict = [String:Any]()
        
        dict["orderId"] = orderId
        dict["customerName"] = customerName
        dict["customerContactNumber"] = customerContactNumber
        dict["customerAddress"] = customerAddress
        dict["customerId"] = customerId
        dict["totalAmount"] = totalAmount
        dict["kitchenName"] = kitchenName
        dict["kitchenId"] = kitchenId
        dict["kitchenOrderReference"] = kitchenOrderReference
        dict["isOrderCompleted"] = isOrderCompleted
        dict["dishToOrder"] = convertToFireStoreType()
        return dict
    }
    
    // Code reference from URL- https://stackoverflow.com/questions/55069016/how-to-store-an-array-of-objects-in-firestore
    func convertToFireStoreType() -> [Any]{
        
        var fireStoreOrders = [Any]()
        
        Utilities.dishesToOrder.forEach { (dish) in
            do{
                let jsonData = try JSONEncoder().encode(dish)
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                fireStoreOrders.append(jsonObject)
            }
            catch {
                print("error in converting dishes to Order ")
            }
        }
        
        return fireStoreOrders
    }
}
