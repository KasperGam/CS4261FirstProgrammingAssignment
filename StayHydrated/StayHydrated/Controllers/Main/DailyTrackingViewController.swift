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
        navigationItem.title = "Daily Hydration"
        
        if let user = AuthenticationStore.auth?.currentUser {
            nameLabel.text = user.displayName
            print(user.uid)
            let database = Database.database().reference()
            let uservalues = database.child("UserData")
            guard let thisuser = AuthenticationStore.currentDBUser else { return }
            thisuser.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard
                let value = snapshot.value as? [String: Any],
                    let entries = value["entries"] as? [String: Any],
                    let weakSelf = self
                    else {
                        uservalues.child(user.uid).setValue(["entries":
                            [self!.getTodayString(): ["amount": 0]]])
                        return
                }
                
                if  let entry = entries[weakSelf.getTodayString()] as? [String: Any] {
                        if let amount = entry["amount"] as? NSNumber {
                            weakSelf.setProgress(amount: Int(truncating: amount))
                        }
                }
                
            })
        }
        
    }
    
    @IBAction func addDrinkPressed(_ sender: Any) {
        
        
    }
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.string(from: Date())
    }
    
    private func checkDates(_ checkDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return checkDate == formatter.string(from: Date())
    }

    private func setProgress(amount: Int) {
        print(amount)
        let percent = CGFloat(amount) / 64.0
        consumptionView.percentComplete = percent
        progressIndicator.text = "\(percent*100) %"
    }

}
