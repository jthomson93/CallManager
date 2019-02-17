//
//  PreviousCallVC.swift
//  CallManager
//
//  Created by James Thomson on 17/02/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class PreviousCallVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventManagerNameLbl: UILabel!
    @IBOutlet weak var callDateLbl: UILabel!
    @IBOutlet weak var ticketsLbl: UILabel!
    @IBOutlet weak var eventAttendanceLbl: UILabel!
    @IBOutlet weak var notesTextAreaLbl: UITextView!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var todoItems = [TodoItem]()
    let formatter = DateFormatter()
    let date = Date()
    var callID = String()
    var eventID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        prepareCall()
        prepareTodoList()
        prepareOrLoadNotes()
    }
    
    //MARK: - Loads the notes snapshot from the server
    
    func prepareOrLoadNotes() {
        let docRef = db.collection("events/\(eventID)/calls").document(callID)
        
        docRef.getDocument { (document, err) in
            if document?.data()?["EventNotesSnapshot"] == nil {
                print("ERROR: - The notes are currently empty")
            } else {
                self.notesTextAreaLbl.text = (document!.data()?["EventNotesSnapshot"] as! String)
                self.notesTextAreaLbl.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK: - Prepare the todo list section
    
    func prepareTodoList() {
        db.collection("events/\(eventID)/todoList").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("ERROR: Could not get the todo list items - ", err)
            } else {
                for documents in querySnapshot!.documents {
                    var newTodoItem = TodoItem()
                    if let todoItemDescription = documents.data()["itemTitle"] {
                        newTodoItem.listItem = todoItemDescription as! String
                    }
                    if let todoItemComplete = documents.data()["isComplete"] {
                        newTodoItem.isComplete = todoItemComplete as! Bool
                    }
                    self.todoItems.append(newTodoItem)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    //MARK: - Load old call details
    
    func prepareCall() {
        let eventDocRef = db.collection("events").document(eventID)
        let callDocRef = db.collection("events/\(eventID)/calls").document(callID)
        
        eventDocRef.getDocument { (document, err) in
            if let err = err {
                print("ERROR: - Could not load the event documents ", err)
            } else {
                if let eventManagerName = document?.data()!["eventManagerName"] {
                    self.eventManagerNameLbl.text = eventManagerName as? String
                }
            }
        }
        
        callDocRef.getDocument { (document, err) in
            if let err = err {
                print("ERROR: - Could not load the call documents ", err)
            } else {
                if let currentAttendance = document?.data()!["currentAttendance"] {
                    self.eventAttendanceLbl.text  = currentAttendance as? String
                }
                
                if let currentTickets = document?.data()!["currentTicketCount"] {
                    self.ticketsLbl.text  = currentTickets as? String
                }
                
                if let callDate = document?.data()!["callDate"] {
                    self.callDateLbl.text  = "Call Date: \(callDate as! String)"
                }
            }
        }
    }

    
    //MARK: - Tableview protocol stubs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom")
        cell?.textLabel!.text = todoItems[indexPath.row].listItem
        return cell!
    }

}
