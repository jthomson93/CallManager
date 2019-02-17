//
//  NewEventVC.swift
//  CallManager
//
//  Created by James Thomson on 23/01/2019.
//  Copyright © 2019 James Thomson. All rights reserved.
//

import UIKit
import Firebase


protocol CanReceive {
    func updateEvents()
}

class NewEventVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var eventManagerNameTextField: UITextField!
    @IBOutlet weak var datePickerDate: UIDatePicker!
    var selectedBrand = Brand()
    var brands = [Brand]()
    var dateSelected = String()
    var delegate : CanReceive?
    let db = Firestore.firestore()
    var UID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        setUpBrands()
        brandImage.image = UIImage(named: brands[0].brandIcon)
        brandPicker.delegate = self
        brandPicker.dataSource = self
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let formatter = DateFormatter()
        let date = datePickerDate.date
        formatter.dateFormat = "dd/MM/yy"
        
        dateSelected = formatter.string(from: date)
    }
    
    //MARK: - PICKERVIEW DELEGATE STUBS AND DATA SOURCE METHODS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brands[row].brandName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBrand = brands[row]
        brandImage.image = UIImage(named: selectedBrand.brandIcon)
    }
    
    //MARK: - SAVE EVENT TO FIREBASE AND THE EVENT OBJECT
    
    @IBAction func saveEvent(_ sender: Any) {
        print("Trying to Save and return")
        var ref: DocumentReference? = nil
        let user = Auth.auth().currentUser
        if let user = user {
            UID = user.uid
            ref = db.collection("events").addDocument(data: [
                "submitedBy": UID,
                "brandName": selectedBrand.brandName,
                "brandIcon": selectedBrand.brandIcon,
                "dateOfEvent": dateSelected,
                "eventCity": cityTextField.text!,
                "eventManagerName": eventManagerNameTextField.text!], completion: { (err) in
                    if let err = err {
                        print ("Error writing event: \(err)")
                    } else {
                        print("Event stored in DB succcessfully!")
                    }
            })
            db.collection("users").document(UID).setData(["events": FieldValue.arrayUnion([ref!])], merge: true)
            
            // LETTING THE MAIN EVENT VC KNOW THAT AN EVENT HAS BEEN ADDED AND IT NEEDS TO RELOAD THE EVENT ARRAY.
            delegate?.updateEvents()
        } else {
            print("ERROR: UID cannot be identified because the user cannot be found when saving event.")
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Set up the brands
    
    func setUpBrands() {
        let applebum = Brand()
        let triplecooked = Brand()
        let party = Brand()
        let mischief = Brand()
        
        applebum.brandName = "Applebum"
        applebum.brandIcon = "applebum"
        triplecooked.brandName = "Triple Cooked"
        triplecooked.brandIcon = "1089298_1_triple-cooked-manchester-weird-wonderful-day-night_400"
        party.brandName = "P.A.R.T.Y."
        party.brandIcon = "party"
        mischief.brandName = "Mischief"
        mischief.brandIcon = "mischief"
        
        brands.append(applebum)
        brands.append(triplecooked)
        brands.append(party)
        brands.append(mischief)
    }
    
}

