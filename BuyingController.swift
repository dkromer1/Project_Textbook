//
//  BuyingController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/6/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class BuyingController: UITableViewController {     //User's Cart

    //----------------------------------------------------------------------
    //--------------------VARIABLES-----------------------------------------
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    var books = [Book]()
    var carts = [Cart]()
    var myList:[String] = []
    
    //-----------------------------------------------------------------------//
    //------------------MAIN-------------------------------------------------//
    
    override func viewDidLoad() {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        //----------------DATA SNAPSHOT---------------------//
        //-------------------------------------------------//
        ref.child("Users").child(uid!).child("Buying").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let book1 = Cart()
                book1.title = dictionary["title"] as? String
                book1.bookID = dictionary["book ID"] as? String
                book1.sellerID = dictionary["seller ID"] as? String
                
                
                self.carts.append(book1)
                self.tableView.reloadData()
                self.ref?.keepSynced(true)
                print(book1)
            }
        })

        
    }
    
    @IBAction func signoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "LoggedOut", sender: self)
            dismiss(animated: true, completion: nil)
        } catch {
            print("There was a problem logging out")
        }
    }
    
    //------------------TABLE VIEW DATA SOURCE--------------------------------//
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return carts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let buying = carts[indexPath.row]
        cell.textLabel?.text = buying.title
        
        return cell
    }
    
    //------------------------When TableView Cell is CLICKED:-------------------------------//
    //---------------------------display alert with actions for book------------------------//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let buying = carts[indexPath.row]
        
        let alertController = UIAlertController(title: "Textbook Exchange", message: "", preferredStyle: .alert)
        alertController.addTextField { (messageText) in messageText.placeholder = "Send Message to Seller"}
        
        //-----------MESSAGE SELLER Action--------------------//
        
        alertController.addAction(UIAlertAction(title: "Send Message", style: .default, handler: { (action) -> Void in
            let alertText = alertController.textFields![0]
            let value = ["title": buying.title!, "book ID": buying.bookID, "to ID" : buying.sellerID, "from ID" : uid!, "text": alertText.text!]
            let key = self.ref?.child("Messages").childByAutoId().key
            self.ref?.child("Users").child(uid!).child("Messages").child(key!).setValue(value)
            self.ref?.child("Messages").child(key!).setValue(value)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))  //Cancels Alert
        self.present(alertController, animated: true, completion: nil)
    }
}

