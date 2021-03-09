//
//  ViewController.swift
//  FourSquareCloneFirebase
//
//  Created by Muhammet Midilli on 8.03.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //sign in with existed user
    @IBAction func signinClicked(_ sender: Any) {
        if emailText.text != nil && passwordText.text != nil {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    //localizedDescription is otomatic error message
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    //open the TableViewVC
                    self.performSegue(withIdentifier: "totableviewvc", sender: nil)
                }
            }
        } else {
            makeAlert(messageInput: "Username and password cannot be empty!")
        }
    }
    
    //creating a new user/signup
    @IBAction func signupClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    //localizedDescription is otomatic error message
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    self.performSegue(withIdentifier: "totableviewvc", sender: nil)
                }
            }
        }
        
    }
    
    //alert func to use many times
    func makeAlert(messageInput : String) {
        let alert = UIAlertController(title: "Error!", message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
}

