//
//  UserPage.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/6/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class UserPage: UIViewController{

    //----------------------------------------------------------------------
    //--------------------VARIABLES-----------------------------------------
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    
    var books = [Book]()
    var myList:[String] = []
    
    //-----------------------------------------------------------------------//
    //------------------MAIN-------------------------------------------------//
    
    override func viewDidLoad() {

    }

    //------------------------------------------------------------------------
    //------------------ADD ITEM TO FIREBASE DATABASE-------------------------
    @IBAction func addItemButton(_ sender: Any) {
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: "Add Book", message: "Enter Book Details", preferredStyle: .alert)
        
        alert.addTextField { (title) in title.placeholder = "Enter Title"}
        alert.addTextField { (price) in price.placeholder = "Enter Price"}
        alert.addTextField { (condition) in condition.placeholder = "Enter Condition"}
        alert.addTextField { (isbn) in isbn.placeholder = "Enter ISBN #"}
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add Book", style: .default, handler: { (action) in
            
            let titleText = alert.textFields![0]
            let priceText = alert.textFields![1]
            let conditionText = alert.textFields![2]
            let isbnText = alert.textFields![3]
            let key = self.ref.child("Books").childByAutoId().key
            let book1 = ["title": titleText.text!, "price": priceText.text!, "condition": conditionText.text!, "ISBN": isbnText.text!, "user ID" : uid!, "book ID": key]
            let book2 = ["title": titleText.text!, "book ID" : key]
           //Add 2 references of book to DB (Books and Users)//
            self.ref.child("Books").child(key).setValue(book1)
            self.ref.child("Users").child(uid!).child("Selling").childByAutoId().setValue(book2)
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
    //---------------------- SIGN OUT ----------------------------------------------------------
    @IBAction func signoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "LoggedOut", sender: self)
            dismiss(animated: true, completion: nil)
        } catch {
            print("There was a problem logging out")
        }
    }
}
