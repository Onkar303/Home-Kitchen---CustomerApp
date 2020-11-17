//
//  Utilities.swift
//  CustomerApp
//
//  Created by user173285 on 11/16/20.
//

import UIKit
import Foundation
import  CryptoKit

class Utilities{
   
    static let userId = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERID)
    
    static let userFirstName = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_FIRSTNAME)
    
    static let userLastName = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_LASTNAME)
   static let userAddress = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERADDRESS)
    static let userContactNumber = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERCONTACTNUMBER)
    
    //Function to save the userid and password inside the app
    static func setUserDefaults(email:String?, password:String?){
        
        guard let email = email else {return}
        guard let password = password else {return}
        
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(email, forKey: Constants.USERDEFAULTS_USERNAME)
        userDefaults.setValue(password, forKey: Constants.USERDEFAULTS_PASSWORD)
        userDefaults.setValue(MD5(string:email+password),forKey:Constants.USERDEFAULTS_USERID)
       }
    //Retriving the hash
    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
                String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    //MARK:- Saving Import data into Userdefaults from firestore
    static func setUserDefaults(userDictionary:[String:Any]?){
        guard let userDictionary = userDictionary else {return}
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_USERNAME], forKey: Constants.USERDEFAULTS_USERNAME)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_PASSWORD], forKey: Constants.USERDEFAULTS_PASSWORD)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_USERID], forKey: Constants.USERDEFAULTS_USERID)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_FIRSTNAME], forKey: Constants.USERDEFAULTS_FIRSTNAME)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_LASTNAME], forKey: Constants.USERDEFAULTS_LASTNAME)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_USERCONTACTNUMBER], forKey: Constants.USERDEFAULTS_USERCONTACTNUMBER)
        userDefaults.setValue(userDictionary[Constants.USERDEFAULTS_USERADDRESS], forKey: Constants.USERDEFAULTS_USERADDRESS)
        
    }
    
    
    
    // Function for Show Message
    static func showMessage(title: String?, message: String?) -> UIAlertController{
        guard let title = title else { return UIAlertController()}
        guard let message = message else{return UIAlertController()}
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        
        alertcontroller.addAction(alertAction)
        return alertcontroller
    }
    
    static func removeUserDefaults(){
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: Constants.USERDEFAULTS_USERNAME)
        userDefaults.removeObject(forKey: Constants.USERDEFAULTS_PASSWORD)
    }
    
    
    
}
