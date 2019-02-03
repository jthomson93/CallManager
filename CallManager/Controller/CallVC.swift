//
//  CallVC.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit

protocol SendList {
    func listRecieved(list: [TodoItem])
}

class CallVC: UITableViewController {

    @IBOutlet var callTableView: UITableView!
    var todoListItems = [TodoItem]()
    var delegate: SendList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callTableView.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "customCallCell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoListItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCallCell", for: indexPath)
        cell.textLabel?.text = todoListItems[indexPath.row].listItem

        return cell
    }

    @IBAction func addTodoItem(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            var newItem = TodoItem()
            
            newItem.listItem = textField.text!
            newItem.isComplete = false // REQUIRED BECASUE IT IS REQUIRED IN COREDATA
            self.todoListItems.append(newItem)
            self.delegate?.listRecieved(list: self.todoListItems)
            
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
