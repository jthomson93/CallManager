//
//  EventVC.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class EventVC: UITableViewController, CanReceive, SendList {

    

    @IBOutlet var eventTableView: UITableView!
    var events = [Event]()
    var passValue = [TodoItem]()
    var passEvent: Event?
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        // Do any additional setup after loading the view.
        eventTableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        configureTableView()
        updateEvents()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        cell.brandIconImage.image = UIImage(named: events[indexPath.row].brand.brandIcon)
        cell.cityName.text = events[indexPath.row].city
        cell.eventManagerName.text = events[indexPath.row].eventManagerName
        
        return cell
    }
    
    func configureTableView() {
        eventTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passValue = events[indexPath.row].todolist
        passEvent = events[indexPath.row]
        performSegue(withIdentifier: "goToCallView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewEvent" {
            let newEvent = segue.destination as! NewEventVC
            newEvent.delegate = self
        }
        
        if segue.identifier == "goToCallView" {
            let newCall = segue.destination as! CallVC
            newCall.delegate = self
            newCall.todoListItems = passValue

        }
    }
    @IBAction func newEventBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: "goToNewEvent", sender: self)
    }
    
    func updateEvents() {
        db.collection("events").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("ERROR: Could not get the documents from events collection: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        print("The data is recieved")
        tableView.reloadData()
    }
    
    func listRecieved(list: [TodoItem]) {
        passEvent!.todolist = list
        print("Got the list")
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        print("Sign Out Button Pressed")
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
            print("Sign Out: SUCCESSFUL!")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    

}
