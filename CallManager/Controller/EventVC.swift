//
//  EventVC.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase

class EventVC: UITableViewController, CanReceive {

    

    @IBOutlet var eventTableView: UITableView!
    var events = [Event]()
    var passEventID = String()
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
        cell.brandIconImage.image = UIImage(named: events[indexPath.row].icon)
        cell.cityName.text = events[indexPath.row].city
        cell.eventManagerName.text = events[indexPath.row].eventManagerName
        
        return cell
    }
    
    func configureTableView() {
        eventTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passEventID = events[indexPath.row].EID
        performSegue(withIdentifier: "goToCallView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewEvent" {
            let newEvent = segue.destination as! NewEventVC
            newEvent.delegate = self
        }
        
        if segue.identifier == "goToCallView" {
            let newCall = segue.destination as! CallVC
            newCall.eventID = passEventID
        }
    }
    
    @IBAction func newEventBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: "goToNewEvent", sender: self)
    }
    
    func updateEvents() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        events.removeAll()
        
        db.collection("events").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("ERROR: Could not get the documents from events collection: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let EID = document.documentID
                    let brand: String = document.data()["brandName"]! as! String
                    let icon: String = document.data()["brandIcon"]! as! String
                    let eventDate: Date = formatter.date(from: document.data()["dateOfEvent"]! as! String)!
                    let city: String = document.data()["eventCity"]! as! String
                    let manager: String = document.data()["eventManagerName"]! as! String
                    let newEvent = Event(eventid: EID, eventBrandName: brand, eventBrandIcon: icon, dateofEvent: eventDate, eventCity: city, emName: manager)
                    self.events.append(newEvent)
                    self.tableView.reloadData()
                }
            }
        }
        
        print("The data is recieved")
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
