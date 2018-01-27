//
//  SignInController.swift
//  Project_Textbook
//
//  Created by Dean Kromer on 9/19/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
 //   var userID = Auth.auth().currentUser?.uid
    
    var ref: DatabaseReference!

//---------------------------------------------------------------------------------
//---------------------- SIGN IN EXISTING ACCOUNT----------------------------------
//---------------------------------------------------------------------------------
    @IBAction func loginButton(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
            Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {
                    let signuperrorAlert = UIAlertController(title: "Login Error", message: "\(error?.localizedDescription) Please try again", preferredStyle: .alert)
                    signuperrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(signuperrorAlert, animated: true, completion: nil)
                    return
                }
                
                if user!.isEmailVerified {
                    self.performSegue(withIdentifier: "LoggedIn", sender: self)
                } else {
                    let emailNOTVerifiedAlert = UIAlertController(title: "Not Verified", message: "\(error?.localizedDescription) Acount pending verification. Please check email and verify account", preferredStyle: .alert)
                    emailNOTVerifiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emailNOTVerifiedAlert, animated: true, completion: nil)
                }
            })
    
    }
//---------------------------------------------------------------------------------
//---------------------- CREATE USER ACCOUNT --------------------------------------
//---------------------------------------------------------------------------------
    @IBAction func registerButton(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let passwordAgain = passwordAgainTextField.text
        
        if passwordAgain == password {
                Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                        if error != nil {
                            let signuperrorAlert = UIAlertController(title: "Signup Error", message: "\(error?.localizedDescription) Please try again", preferredStyle: .alert)
                            signuperrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(signuperrorAlert, animated: true, completion: nil)
                            return
                        }
                    self.sendEmail()
                    self.dismiss(animated: true, completion: nil)
                })
        }   else{
            let passwordNotMatchAlert = UIAlertController(title: "Password Mismatch", message: "Make sure passwords match", preferredStyle: .alert)
            passwordNotMatchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.passwordTextField.text = ""
                self.passwordAgainTextField.text = ""
            }))
            present(passwordNotMatchAlert, animated: true, completion: nil)
        }
    }
    
//---------------------- EMAIL VERIFICATION send --------------------------------
    func sendEmail() {
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                let emailNOTsentAlert = UIAlertController(title: "Email Verification", message: "\(error?.localizedDescription) Email Verification failed to send", preferredStyle: .alert)
                emailNOTsentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(emailNOTsentAlert, animated: true, completion: nil)
            } else {
                let emailSentAlert = UIAlertController(title: "Email Verification", message: " Email Verification Sent", preferredStyle: .alert)
                emailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(emailSentAlert, animated: true, completion: nil)
                    //self.dismiss(animated: true, completion: nil)
            }
        })
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
    }
    
//---------------------- ALERT HANDLER ---------------------------------------------------
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Textbook Exchange", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
//---------------------- SIGN OUT ----------------------------------------------------------
    @IBAction func signoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("There was a problem logging out")
        }
    }
    
    
}           //end
