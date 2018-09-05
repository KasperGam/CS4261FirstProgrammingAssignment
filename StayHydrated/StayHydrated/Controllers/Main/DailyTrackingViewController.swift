//
//  DailyTrackingViewController.swift
//  StayHydrated
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DailyTrackingViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var consumptionView: WaterConsumptionView!
    
    @IBOutlet weak var progressIndicator: UILabel!

    
    override func viewDidLoad() {
        // Load code here
        self.title = "Daily Hydration"
        
        if let user = AuthenticationStore.auth?.currentUser {
            nameLabel.text = user.displayName
            print(user.uid)
            let database = Database.database().reference()
            let uservalues = database.child("User")
            print(uservalues.description())
            uservalues.childByAutoId().setValue(["userid": user.uid, "entries": []])
            let thisuser = uservalues.queryEqual(toValue: user.uid, childKey: "userid")
            print(thisuser.description)
            thisuser.observe(.value, with: { [weak self] (snapshot) in
                guard
                    let value = snapshot.value as? NSDictionary,
                    let entries = value["entries"] as? [NSDictionary],
                    let weakSelf = self
                    else {
                        return
                }
                for entry in entries {
                    if let entryDate = entry["date"] as? Date,
                        weakSelf.checkDates(entryDate) {
                            if let amount = entry["amount"] as? NSNumber {
                                weakSelf.setProgress(amount: Int(truncating: amount))
                            }
                    }
                }
            })
            // Make API call to firebase with user to get
        }
        
    }
    
    @IBAction func addDrinkPressed(_ sender: Any) {
        
        
    }
    
    private func checkDates(_ checkDate: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()

        if calendar.component(.year, from: checkDate) != calendar.component(.year, from: currentDate) {
            return false
        } else if calendar.component(.weekOfYear, from: checkDate) != calendar.component(.weekOfYear, from: currentDate) {
            return false
        } else if calendar.component(.day, from: checkDate) != calendar.component(.day, from: currentDate) {
            return false
        }
        return true
    }

    private func setProgress(amount: Int) {
        print(amount)
    }

}
