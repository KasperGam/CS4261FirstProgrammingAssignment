//
//  ViewController.swift
//  StayHydrated
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {
    
    var authVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func presentLogin(_ sender: Any) {
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        authUI.providers = [FUIGoogleAuth()]
        authVC = authUI.authViewController()
        self.present(authVC!, animated: true, completion: nil)
    }
    
    
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // Handle sign in
        guard error == nil else { print("Error: \(error!.localizedDescription)"); return }
        print("User signed in!")
        AuthenticationStore.auth = authUI.auth
        authVC?.dismiss(animated: false, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabVC = storyboard.instantiateInitialViewController() else { return }
        

        navigationController?.setViewControllers([tabVC], animated: true)
        UINavigationBar.appearance().backgroundColor = UIColor.blue
        navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
}

