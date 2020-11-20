//
//  SignupViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController:UIViewController{
    
    static let CONTROLLER_IDENTIFIER = "SignupController"
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    var authController:Auth!
    var fireStore:Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
        attachDelegates()
        configureUI()
    }
    
    
    
    //MARK:- Attaching delegates
    func attachDelegates(){
        emailTextView.delegate = self
        passwordTextView.delegate = self
    }
    
    //MARK:- ConfigureUI
    func configureUI(){
        //passwordTextView.isSecureTextEntry = true
    }
    
    //MARK:- Initialize firebaseAuth
    func configureFirebase(){
        authController = Auth.auth()
        fireStore = Firestore.firestore()
    }
    
    
    //MARK:-Sign Up function call
    @IBAction func tapSignUp(_ sender: Any) {
        createNewCustomer()
    }
    
    //MARK:- Creating a new user
    func createNewCustomer(){
        guard let email = emailTextView.text else{return}
        guard let password = passwordTextView.text else {return}
        authController.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let _ = error {
                print("Error in signup")
            }else{
                Utilities.setUserDefaults(email: email, password: password)
                self.sendDataToFirebase { (isSuccessfull) in
                    if isSuccessfull {
                        self.segueToHomeViewController()
                    }
                }
            }
        }
    }
    
    //MARK:- Performing segue to HomeViewController
    func segueToHomeViewController(){
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: .main)
        let homeViewController = storyBoard.instantiateViewController(identifier:"HomeNavigationController")
        present(homeViewController, animated: true, completion: nil)
        view.endEditing(true)
        
    }
    
    //MARK:- Sending UserInfo to firebase
    func sendDataToFirebase(isSuccessfull:@escaping (Bool) -> Void){
        
        fireStore.collection(Constants.FIRE_STORE_CUSTOMER_COLLECTION_NAME).document(UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_CUSTOMERID)!).setData(createCustomerDictionary()) { (error) in
            if let error = error {
                print("error sending data \(error)")
                //remove all user defaults
                isSuccessfull(false)
                return
            }
            isSuccessfull(true)
        }
    }
    
    //MARK:- creating Customer Dictionary
    func createCustomerDictionary() -> [String:Any] {
        let customer = Customer()
        customer.email = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERNAME)
        customer.password = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_PASSWORD)
        customer.customerId = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_CUSTOMERID)
        customer.firstName = ""
        customer.lastName = ""
        customer.address = ""
        customer.contactNumber = ""
        return customer.convertToDictionary()
    }
    
}

// MARK:- Handling the software keyboard
extension SignupViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
