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
    
    static let ERROR = "ERROR"
    static let SUCCESS = "SUCCESS"
    
    //MARK:- AccountDetailsViewController
    static let ACCOUNT_PASSWORD_PARAM = "Password"
    static let ACCOUNT_USER_FIRST_NAME_PARAM = "First Name"
    static let ACCOUNT_USER_LAST_NAME_PARAM = "Last Name"
    static let ACCOUNT_USER_ADDRESS_PARAM = "User Address"
    static let ACCOUNT_USER_CONTACT_NUMBER_PARAM = "Contact Number"
    
        static let ACCOUNT_INFO_PARAMS = [ACCOUNT_PASSWORD_PARAM,ACCOUNT_USER_FIRST_NAME_PARAM,ACCOUNT_USER_LAST_NAME_PARAM,ACCOUNT_USER_ADDRESS_PARAM,ACCOUNT_USER_CONTACT_NUMBER_PARAM]
        static let ACCOUNT_PARAM_SECTION_HEADER = "Account"
        static let ACCOUNT_SIGNOUT_SECTION_HEADER = "Signout"

    }

//User Defaults
extension Constants{
    static let USERDEFAULTS_USERNAME = "email"
    static let USERDEFAULTS_PASSWORD = "password"
   static let USERDEFAULTS_USERID = "UserID"
    static let USERDEFAULTS_FIRSTNAME = "FisrtName"
    static let USERDEFAULTS_LASTNAME = "LastName"
   static let USERDEFAULTS_USERADDRESS="UserAddress"
    static let USERDEFAULTS_USERCONTACTNUMBER="UserContactNumber"
}

