//
//  CallVC.swift
//  CallManager
//
//  Created by James Thomson on 17/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit

class CallVC: UITableViewController {

    @IBOutlet var callTableView: UITableView!
    var eventID = String()
    var calls:[Call] = [Call]()
    
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
        return calls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCallCell", for: indexPath)
        
        return cell
    }

    @IBAction func addNewCall(_ sender: Any) {
        performSegue(withIdentifier: "goToNewCallVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewCallVC" {
            let newCallVC = segue.destination as! NewCallVC
            print(eventID)
            newCallVC.callEventID = eventID
        }
    }

    
}
