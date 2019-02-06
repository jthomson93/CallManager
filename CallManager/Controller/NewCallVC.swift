//
//  NewCallVC.swift
//  CallManager
//
//  Created by James Thomson on 23/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class NewCallVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var callEventID = String()
    let db = Firestore.firestore()
    var todoItems = [TodoItem]()
    @IBOutlet weak var eventManagerNameLabel: UILabel!
    @IBOutlet weak var currentCallDateLbl: UILabel!
    @IBOutlet weak var previousTicketCount: UILabel!
    @IBOutlet weak var previousEventAttendance: UILabel!
    @IBOutlet weak var eventNotes: UITextView!
    @IBOutlet weak var tablewView: UITableView!
    @IBOutlet weak var currentTickets: UITextField!
    @IBOutlet weak var currentAttendance: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablewView.delegate = self
        tablewView.dataSource = self
        // Do any additional setup after loading the view.
        getEventInfo(eventID: callEventID)
        prepareOrLoadNotes()
        prepareCall()
        print(callEventID)
    }
    
    func getEventInfo(eventID: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let docRef = db.collection("events").document(eventID)
        
        docRef.getDocument { (document, err) in
            if let err = err {
                print(err)
            } else {
                //TODO: Change change navigation controller title to be relfective of the brand
            }
        }
        
    }
    
    func prepareOrLoadNotes() {
        let docRef = db.collection("events").document(callEventID)
        
        docRef.getDocument { (document, err) in
            if document?.data()?["EventNotes"] == nil {
                self.eventNotes.text = "Put your notes here! They will save and carry over for each call."
            } else {
                self.eventNotes.text = (document!.data()?["EventNotes"] as! String)
            }
        }
    }
    
    func prepareCall() {
        let docRef = db.collection("events").document(callEventID)
        
        docRef.getDocument { (document, err) in
            if let err = err {
                print("ERROR: Could not get documents in the event: ", err)
            } else {
                if let eventManagerName = document?.data()!["eventManagerName"] {
                    self.eventManagerNameLabel.text = eventManagerName as? String
                }
                if let currentTickets = document?.data()!["currentTicketCount"] {
                    self.previousTicketCount.text = currentTickets as? String
                } else {
                    self.previousTicketCount.text = "0"
                }
                if let previousAttendance = document?.data()!["currentAttendance"] {
                    self.previousEventAttendance.text = previousAttendance as? String
                } else {
                    self.previousEventAttendance.text = "0"
                }
            }
        }
    }
    
    //TODO: - Implement the todo list global to each call in the event
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom")
        cell?.textLabel!.text = "Test"
        return cell!
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        db.collection("events").document(callEventID).setData(["currentTicketCount": currentTickets.text!,
                                                               "currentAttendance": currentAttendance.text!,
                                                               "EventNotes": eventNotes.text], merge: true)
        navigationController?.popViewController(animated: true)
    }
    
}
