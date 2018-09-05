//
//  AddDrinkViewController.swift
//  StayHydrated
//

import UIKit
import FirebaseDatabase

class AddDrinkViewController: UIViewController {
    
    @IBOutlet weak var amountPickerView: UIPickerView!
    
    @IBOutlet weak var typePickerView: UIPickerView!
    
    
    private let amountValues = ["1", "2", "3", "4", "5", "6", "7", "8"]
    private let typeValues = ["cup", "ounce", "glass"]
    
    override func viewDidLoad() {
        amountPickerView.delegate = self
        amountPickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addDrink))
        navigationItem.title = "Add Drink"
    }
    
    @objc
    func addDrink() {
        guard var amount = Int(amountValues[amountPickerView.selectedRow(inComponent: 0)]) else { return } // TODO: Fail message
        switch typePickerView.selectedRow(inComponent: 0) {
        case 0, 2: amount *= 8
        default: break
        }
        
        guard let user = AuthenticationStore.currentDBUser else {return } // TODO: fail message
        
        let entries = user.ref.child("entries")
        let entry = entries.child(getTodayString())
        entry.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else {
                entry.setValue(["amount": amount])
                self.navigationController?.popViewController(animated: true)
                return
            }
            if let curAmount = value["amount"] as? NSNumber {
                amount += Int(truncating: curAmount)
            }
            entry.ref.child("amount").setValue(amount)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.string(from: Date())
    }
    
}

extension AddDrinkViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == amountPickerView {
            return amountValues.count
        } else if pickerView == typePickerView {
            return typeValues.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == amountPickerView {
            return NSAttributedString(string: amountValues[row])
        } else if pickerView == typePickerView {
            return NSAttributedString(string: typeValues[row])
        }
        return NSAttributedString()
    }
    
}
