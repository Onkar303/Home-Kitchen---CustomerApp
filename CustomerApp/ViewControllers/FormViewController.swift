//
//  FormViewController.swift
//  CustomerApp
//
//  Created by user173285 on 11/17/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FormViewController: UIViewController{
    
    @IBOutlet weak var paramTitleLabel: UILabel!
    @IBOutlet weak var commonTextField: CustomTextField!
    static let STORYBOARD_IDENTIFIER = "FromViewController"
    
    
    var titleLabel: String?
    var value: String?
    var firebaseAuth:Auth?
    var firesStore:Firestore?
    var responseDelegate:ResponseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        //configureFirebase()
        
    }
    
    //Function to configure UI
    func configureUI(){
        paramTitleLabel.text = titleLabel
        guard let value = value else{return}
        commonTextField.text = value
        
        if paramTitleLabel.text == Constants.ACCOUNT_PASSWORD_PARAM{
            commonTextField.isSecureTextEntry = true
        }
    }
    
    //Function to Configure Firebase
    func configureFirebase(){
        firebaseAuth = Auth.auth()
        firesStore = Firestore.firestore()
    }
    
    //Function for SAVE Button
    @IBAction func saveTapped(_ sender: Any){
        guard let title = titleLabel, !title.isEmpty else{return}
        guard let text = commonTextField.text, !text.isEmpty else{return}
        
        
        if title == "Password"{
            changePassword(password: text)
        }else if title == "First Name"{
            updateUser(updateField: Constants.USERDEFAULTS_FIRSTNAME, text: text)
        }else if title == "Last Name"{
            updateUser(updateField: Constants.USERDEFAULTS_LASTNAME, text: text)
        }else if title == "Contact Number"{
            updateUser(updateField: Constants.USERDEFAULTS_USERCONTACTNUMBER, text: text)
        }else{
            updateUser(updateField: Constants.USERDEFAULTS_USERADDRESS, text: text)
        }
    }
    
    // Function to update User
    func updateUser(updateField: String?, text: String){
    
}

    func changePassword(password: String?){
        guard let password = password else{return}
        firebaseAuth?.currentUser?.updateEmail(to: password, completion: { (error) in
            if let error = error{
                self.present(Utilities.showMessage(title: Constants.ERROR, message: error.localizedDescription), animated: true, completion: nil)
                return
            }
            
            self.responseDelegate?.onUpdateResponse(status: true, updateField: "Password")
        })
    }
}
