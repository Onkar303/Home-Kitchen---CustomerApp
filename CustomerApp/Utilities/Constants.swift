//
//  Constants.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation

class Constants{
    static let CORNER_RADIUS:Int = 20
    
    static let BASE_URL = "https://api.spoonacular.com/recipes/complexSearch"
    static let KEY_PARAMETER = "?apiKey="
    static let KEY = "7197d6ced50f405c963c1ea1e7d24844"
    
    
    static func setUserDefaults(email:String?,password:String?){
        
        guard let email = email else {return}
        guard let password = password  else {return}
        
        let defaults = UserDefaults.standard
        defaults.setValue(email, forKey: "email")
        defaults.setValue(password, forKey: "password")
        
        
    }
}
