//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Alim Gönül on 1.05.2023.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .init(UIColor(patternImage: UIImage.init(named: "backround")!))
    }
    // Giriş yapma
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVc", sender: nil)
        
    }
    // 1.Adım
    @IBAction func signUpButton(_ sender: Any) {
        // Kullanıcı oluşturma
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput:error?.localizedDescription ?? "Error" )
                }else{
                    self.performSegue(withIdentifier: "toFeedVc", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
    }
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title:titleInput , message: messageInput , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

