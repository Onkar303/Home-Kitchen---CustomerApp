//
//  SignupViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit
import FirebaseAuth

class SignupViewController:UIViewController{
    
    static let CONTROLLER_IDENTIFIER = "SignupController"
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    var authController:Auth!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFirebaseAuth()
        attachDelegates()
    }
    
    
    
    //MARK:- Attaching delegates
    func attachDelegates(){
        emailTextView.delegate = self
        passwordTextView.delegate = self
    }
    
    //MARK:- Initialize firebaseAuth
    func initFirebaseAuth(){
        authController = Auth.auth()
    }
    
    
    //MARK:-Sign Up function call
    @IBAction func tapSignUp(_ sender: Any) {
        createNewUser()
    }
    
    //MARK:- Creating a new user
    func createNewUser(){
        
        guard let email = emailTextView.text else{
            return
        }
        
        guard let password = passwordTextView.text else {
            return
        }
        
        print(email + " " + password)
        
        authController.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let _ = error {
                print("Error in signup")
            }else{
                print("new user created successfully")
            }
        }
        
    }
    
    //MARK:- Performing segue to HomeViewController
    func segueToHomeViewController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let homeViewController = storyBoard.instantiateViewController(identifier: HomeViewController.CONTROLLER_IDENTIFIER) as! HomeViewController
        present(homeViewController, animated: true, completion: nil)
        view.endEditing(true)
        
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
