//
//  TableViewController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 11/28/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class BooksPage: UITableViewController {

    //----------------------------------------------------------------------//
    //--------------------VARIABLES-----------------------------------------//
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    
    var books = [Book]()
    var myList:[String] = []
   
    //-----------------------------------------------------------------------//
    //------------------MAIN-------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        //----------------DATA SNAPSHOT---------------------//
        //-------------------------------------------------//
        ref.child("Books").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]{
                let book = Book()
                book.userID = dictionary["user ID"] as? String
                book.title = dictionary["title"] as? String
                book.price = dictionary["price"] as? String
                book.condition = dictionary["condition"] as? String
                book.isbn = dictionary["ISBN"] as? String
                book.bookID = dictionary["bookID"] as? String
                self.books.append(book)
                self.tableView.reloadData()
                self.ref?.keepSynced(true)
                
               // print(dictionary)
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

//------------------------------------------------------------------------//
    
    //------------------TABLE VIEW DATA SOURCE--------------------------------//
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return books.count
       // return myList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      //  let indexPath
        let book = books[indexPath.row]
        cell.textLabel?.text =  book.title
        cell.detailTextLabel?.text = "Price:" + book.price!
        
        return cell
    }
    //------------------------When TableView Cell is CLICKED:-------------------------------//
    //---------------------------display alert with actions for book------------------------//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let book = books[indexPath.row]
        let book2 = ["title": book.title, "book ID": book.bookID, "seller ID" : book.userID]
        let alertController = UIAlertController(title: "Textbook Exchange", message: "", preferredStyle: .alert)
        
        //-----------Add Book to Cart--------------------//
        alertController.addAction(UIAlertAction(title: "Add Book to Cart", style: .default, handler: { (action) -> Void in
            
            self.ref.child("Users").child(uid!).child("Buying").childByAutoId().setValue(book2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
            print("Book Added to Cart")
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))  //Cancels Alert
        self.present(alertController, animated: true, completion: nil)
    }

    
}

