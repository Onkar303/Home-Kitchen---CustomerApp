//
//  Customer.swift
//  CustomerApp
//
//  Created by Techlocker on 20/11/20.
//

import Foundation

class Customer {
    var email:String?
    var password:String?
    var customerId:String?
    var firstName:String?
    var lastName:String?
    var contactNumber:String?
    var address:String?
    
    
    func convertToDictionary() -> [String:Any]{
        var dict = [String:Any]()
        dict["email"] = email
        dict["password"] = password
        dict["customerId"] = customerId
        dict["firstName"] = firstName
        dict["lastName"] = lastName
        dict["contactNumber"] = contactNumber
        dict["address"] = address
        return dict
    }
}
