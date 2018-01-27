//
//  NewMessageController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/8/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellID = "cellID"
    
    var messages = [Message]()
    var users = [User]()
    var books = [Book]()
    var myList:[String] = []
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        let message = self.messages
        
        
        
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchMessages() {
        Database.database().reference().child("Messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any]{
                let message = Message()
                message.bookID = dictionary["book ID"] as? String
                message.fromID = dictionary["from ID"] as? String
                message.fromID = dictionary["to ID"] as? String
                message.fromID = dictionary["text"] as? String
                self.messages.append(message)
            }
            
        })
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.title
        cell.detailTextLabel?.text = message.text
            
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = Message()
         //   self.messagesController?.showChatControllerForUser(message: message)
        
    }

    
    class UserCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
}
