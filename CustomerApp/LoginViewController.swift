//
//  ViewController.swift
//  CustomerApp
//
//  Created by Techlocker on 18/10/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var authController:Auth?
    @IBOutlet weak var signupText: UILabel!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        attachDelegates()
        configureUI()
        initAuth()
    }
    
    
    //MARK:- Initializing Auth
    func initAuth(){
        authController = Auth.auth()
    }
    
    //MARK:- Adding tap gesture for Signup label
    func addTapGestureOnSignUpText(){
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(segueToSignUpViewController) )
        signupText.addGestureRecognizer(tapGesture)
        signupText.isUserInteractionEnabled = true
        
    }
    
    //MARK:- attaching delegates
    func attachDelegates(){
        
        emailTextView.delegate = self
        passwordTextView.delegate = self
    }
    
    //MARK:- Configure the UI Elements
    func configureUI(){
        passwordTextView.isSecureTextEntry = true
        addTapGestureOnSignUpText()
    }
    
    
    //MARK:- Moving to signup page
    @objc func segueToSignUpViewController(){
        let storyboard = UIStoryboard.init(name: "Signup", bundle: .main)
        let signupController = storyboard.instantiateViewController(identifier: SignupViewController.CONTROLLER_IDENTIFIER ) as! SignupViewController
        navigationController?.pushViewController(signupController, animated: true)
    }
    
    @IBAction func authenticateWithFirebase(_ sender: Any) {
        
        guard let email = emailTextView.text else{
            return
        }
        
        guard let password = passwordTextView.text else {
            return
        }
        
        authController?.signIn(withEmail: email, password: password, completion: { (authDataResult, error) in
            if let error = error{
                print("an error occured\(error)")
            }else {
                self.segueToHomeViewController()
            }
            
        })
        
    }
    
    //MARK:- Performing segue to HomeViewController
    func segueToHomeViewController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyBoard.instantiateViewController(identifier: TabBarController.CONTROLLER_IDENTIFIER) as! TabBarController
        navigationController?.pushViewController(tabBarController, animated: true)
        
    }
    
}


//MARK:- Handling software keyboard
extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

