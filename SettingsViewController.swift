//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Alim Gönül on 4.05.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutClicked(_ sender: Any) {
        // kullanıcı çıkış yaptıktan sonra Firebaseden'de çıkıyor 
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toFirstVc", sender: nil)
        }
        catch {
            print("Error")
        }
    }
    
}
