//
//  AccountDetailsViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 22/10/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


class AccountDetailsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var authController:Auth?
    var accountParams:[String] = Constants.ACCOUNT_INFO_PARAMS
    
    @IBOutlet weak var accountDetailsTableView: UITableView!
    
    let ACCOUNT_PARAM_SECTION = 0
    let ACCOUNT_SIGNOUT_SECTION = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDelegate()
        instantiateAuth()
        configureUI()
        
    }
    
    func attachDelegate(){
        
        accountDetailsTableView.delegate = self
        accountDetailsTableView.dataSource = self
        
        
    }
    
    //Function To Instanitate Auth
    func instantiateAuth(){
        authController = Auth.auth()
    }
    
    
    // Mark: Function for UI Configure
    func configureUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //Function for Signout
    func signOut(){
        do{
            try authController?.signOut()
            Utilities.removeUserDefaults()
            changeRootController()
            
        } catch let err{
            print("error in sign-in, sign-out\(err)")
        }
    }
    
    //Function for Change in Root Controller
    func changeRootController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginNavigationController")
        UIApplication.shared.windows.first?.rootViewController = loginViewController
    }
    
    
    //MARK:- Presenting FormController Modally
    
    func showFormController(indexPath: IndexPath){
        let storyBoard = UIStoryboard(name: "FormStoryboard", bundle: .main)
        let formViewController = storyBoard.instantiateViewController(identifier: FormViewController.STORYBOARD_IDENTIFIER) as! FormViewController
        formViewController.titleLabel = accountParams[indexPath.row]
        formViewController.responseDelegate = self
        present(formViewController, animated: true, completion: nil)
    }
    
    // Function for Getting User Information
    func getUserInfo(titleLabel:String) -> String? {
        if titleLabel == Constants.ACCOUNT_PASSWORD_PARAM{
            return "*******"
        }else if titleLabel == Constants.ACCOUNT_USER_FIRST_NAME_PARAM{
            //return Utilities.userFirstName
        } else if titleLabel == Constants.ACCOUNT_USER_LAST_NAME_PARAM {
            //return Utilities.userLastName
        } else if titleLabel == Constants.ACCOUNT_USER_CONTACT_NUMBER_PARAM {
            //return Utilities.userContactNumber
        } else {
            return ""
        }
     
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ACCOUNT_PARAM_SECTION {
            return accountParams.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.CELL_IDENTIFIER, for: indexPath) as! AccountTableViewCell
            cell.accountDetailsLabel.text = accountParams[indexPath.row]
            
            if accountParams[indexPath.row] == Constants.ACCOUNT_PASSWORD_PARAM{
                cell.accountDetailsValue.text = "*******"
            }else if accountParams[indexPath.row] == Constants.ACCOUNT_USER_FIRST_NAME_PARAM{
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_FIRSTNAME)
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_USER_LAST_NAME_PARAM {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_LASTNAME)
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_USER_CONTACT_NUMBER_PARAM {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERCONTACTNUMBER)
            } else {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERADDRESS)
            }
            cell.accessoryType = .disclosureIndicator
        
            return cell
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "SignOut"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == ACCOUNT_SIGNOUT_SECTION {
            signOut()
            return
        }
        showFormController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == ACCOUNT_PARAM_SECTION {
            return Constants.ACCOUNT_PARAM_SECTION_HEADER
        }
        return Constants.ACCOUNT_SIGNOUT_SECTION_HEADER
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            return CGFloat(88)
        }
        return CGFloat(44)
    }
    
}

//extension for ResponseDelegate-------- Function for onUpdateResponse

extension AccountDetailsViewController: ResponseDelegate{
    func onUpdateResponse(status: Bool, updateField: String?) {
        if status{
            guard let updateField = updateField else{ return}
           // print(Utilities.userFirstName)
          //  present(Utilities.showMessage(title: Constants.SUCCESS, message: "\(updateField) Update Successful"), animated: true, completion: nil)
        } else{
            
        }
    }
    
    
}
