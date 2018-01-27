//
//  MessagesController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/6/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    //----------------------------------------------------------------------
    //--------------------VARIABLES-----------------------------------------
    var ref: DatabaseReference!
    var handle:DatabaseHandle?
    var messages = [Message]()
    
    //-----------------------------------------------------------------------//
    //------------------MAIN-------------------------------------------------//
    
    override func viewDidLoad() {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        //----------------DATA SNAPSHOT---------------------//
        ref.child("Users").child(uid!).child("Messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any]{
                
                let message = Message()
                message.title = dictionary["title"] as? String
                message.bookID = dictionary["book ID"] as? String
                message.text = dictionary["text"] as? String
                message.toID = dictionary["to ID"] as? String
                message.fromID = dictionary["from ID"] as? String
                self.messages.append(message)
                self.tableView.reloadData()
                self.ref?.keepSynced(true)
                
                print(message)
            }
        })
        
    }
     
   /* func showChatControllerForUser(message: Message) {
        let chatLogController = ChatLogController()
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    */
    
    @IBAction func signoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
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
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let list = messages[indexPath.row]
        cell.textLabel?.text = list.title
        cell.detailTextLabel?.text = list.text
        print(list)
        return cell
    }
    
    //------------------------When TableView Cell is CLICKED:-------------------------------//
    
    //------------------------When TableView Cell is CLICKED:-------------------------------//
    //---------------------------display alert with actions for book------------------------//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let buying = messages[indexPath.row]
        
        let alertController = UIAlertController(title: "Textbook Exchange", message: "", preferredStyle: .alert)
        alertController.addTextField { (messageText) in messageText.placeholder = "Send Message to Seller"}
        
        //-----------MESSAGE SELLER Action--------------------//
        
        alertController.addAction(UIAlertAction(title: "Send Message", style: .default, handler: { (action) -> Void in
            let alertText = alertController.textFields![0]
            let value = ["title": buying.title!, "book ID": buying.bookID, "to ID" : buying.fromID, "from ID" : uid!, "text": alertText.text!]
            let key = self.ref?.child("Messages").childByAutoId().key
            self.ref?.child("Users").child(uid!).child("Messages").child(key!).setValue(value)
            self.ref?.child("Messages").child(key!).setValue(value)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))  //Cancels Alert
        self.present(alertController, animated: true, completion: nil)
    }
}



