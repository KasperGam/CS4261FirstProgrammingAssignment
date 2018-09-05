//
//  HistoryViewController.swift
//  StayHydrated
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        getData()
        tableView.dataSource = self
    }
    
    var data: [String: Any] = [:]
    
    private func getData() {
        guard let user = AuthenticationStore.currentDBUser else {return } // TODO: fail message
        
        let entries = user.ref.child("entries")
        
        entries.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            self.data = value
            self.tableView.reloadData()
        })
        
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        // configure with data
        
        var row = 0
        for key in data.keys {
            if row == indexPath.row {
                cell.dateLabel.text = key
                if let val = data[key] as? [String: Any],
                    let amount = val["amount"] as? NSNumber {
                    
                    cell.percentCompleteLabel.text = "\(Float(truncating: amount)/64.0) %"
                }
                break
            }
            row += 1
        }
        return cell
    }
    
}
