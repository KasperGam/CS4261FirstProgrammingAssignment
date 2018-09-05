//
//  SettingsViewController.swift
//  StayHydrated
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        if let auth = AuthenticationStore.auth {
            do {
                try auth.signOut()
            } catch {
                print("Error signing out")
                
            }
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initVC = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        navigationController?.setViewControllers([initVC], animated: true)
    }
    
}
