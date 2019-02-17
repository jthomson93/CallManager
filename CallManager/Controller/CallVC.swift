//
//  CallVC.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class CallVC: UITableViewController, ReloadTable {

    @IBOutlet var callTableView: UITableView!
    var eventID = String()
    var callID = String()
    var calls:[Call] = [Call]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callTableView.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "customCallCell")
        loadCalls()
    }
    
    // MARK: - Loading the call log from Firebase
    
    func loadCalls() {
        print("RELOAD/LOAD THE CALLS IS BEING ACTIONED")
        calls.removeAll()
        db.collection("events/\(eventID)/calls").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("ERROR: - Problem loading the calls from Firebase: ", err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let eventNoteSnapshot = document.data()["EventNotesSnapshot"] as! String
                    let callCount = document.data()["callCount"] as! Int
                    let callDate = document.data()["callDate"] as! String
                    let attendance = document.data()["currentAttendance"] as! String
                    let tickets = document.data()["currentTicketCount"] as! String
                    
                    let callDocID = document.reference.documentID
                    
                    let newCall = Call(documentID: callDocID, callNumber: callCount, callDate: callDate, callNotesSnapshot: eventNoteSnapshot, ticketCount: tickets, attendCount: attendance)
                    self.calls.append(newCall)
                    self.calls = self.calls.sorted(by: { $0.callNumber < $1.callNumber })
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func reloadTableAfterNewCall() {
        loadCalls()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCallCell", for: indexPath) as! CallCell
        cell.callDateLabel.text = "Call Date: \(calls[indexPath.row].callDate)"
        cell.callNumberLabel.text = "Call #\(calls[indexPath.row].callNumber)"
        
        return cell
    }
    
    //MARK: - Handling the tapped call cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        callID = calls[indexPath.row].documentID
        performSegue(withIdentifier: "goToPreviousCall", sender: self)
    }
    
    //MARK: - Working on the swipe to delete call feature
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let docID = calls[indexPath.row].documentID
        db.collection("events/\(eventID)/calls").document(docID).delete { (err) in
            if let err = err {
                print("ERROR: Could not remove the document: ", err)
            } else {
                print("The document has been deleted!")
                
                self.loadCalls()
            }
        }
    }

    @IBAction func addNewCall(_ sender: Any) {
        performSegue(withIdentifier: "goToNewCallVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewCallVC" {
            let newCallVC = segue.destination as! NewCallVC
            newCallVC.delegate = self
            print(eventID)
            newCallVC.callEventID = eventID
            newCallVC.callCount = calls.count + 1
        }
        
        if segue.identifier == "goToPreviousCall" {
            let callVC = segue.destination as! PreviousCallVC
            callVC.callID = callID
            callVC.eventID = eventID
        }
    }

    
}
