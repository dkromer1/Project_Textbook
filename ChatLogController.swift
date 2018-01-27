//
//  ChatLogController.swift
//  Salisbury_Book_Exchange
//
//  Created by Dean Kromer on 12/8/17.
//  Copyright © 2017 Dean Kromer. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UITableViewController {

    
    var books = [Book]()
    var users = [User]()
    var messages = [Message]()
    var messagesController: MessagesController?
    
    let inputText: UITextField = {
        let inputText = UITextField()
        inputText.placeholder = "Enter Message"
        inputText.translatesAutoresizingMaskIntoConstraints = false
    
        return inputText
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        setupInputComponents()

    }

    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        containerView.addSubview(inputText)
        
        inputText.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputText.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputText.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.blue
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        seperatorLineView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
   
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
       
        let values = ["text": inputText.text]
        childRef.updateChildValues(values)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
