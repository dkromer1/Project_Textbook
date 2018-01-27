//
//  CartController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/6/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class SellingController: UITableViewController {


    //----------------------------------------------------------------------
    //--------------------VARIABLES-----------------------------------------
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    var books = [Book]()
    var myList:[String] = []
    
    //-----------------------------------------------------------------------//
    //------------------MAIN-------------------------------------------------//
    
    override func viewDidLoad() {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        //----------------DATA SNAPSHOT---------------------//

        ref.child("Users").child(uid!).child("Selling").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let book1 = Book()
                book1.title = dictionary["title"] as? String
                book1.bookID = dictionary["book ID"] as? String
                self.books.append(book1)
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
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }
    
    //------------------------When TableView Cell is CLICKED:-------------------------------//
    //---------------------------display alert with actions for book------------------------//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let book = books[indexPath.row]
        
        let alertController = UIAlertController(title: "Textbook Exchange", message: "", preferredStyle: .alert)
        
        //-----------Add Book Action--------------------//
        alertController.addAction(UIAlertAction(title: "Delete Book", style: .default, handler: { (action) -> Void in
            
            self.ref.child("Users").child(uid!).child("Cart").childByAutoId
            print("Book Added to Cart")
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))  //Cancels Alert
        self.present(alertController, animated: true, completion: nil)
    }
}
