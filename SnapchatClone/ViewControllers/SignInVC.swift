//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 21.01.22.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func SignInButtonClicked(_ sender: Any) {
        if self.emailTxtField.text != "" && self.passwordTxtField.text!.count >= 6 {
        Auth.auth().signIn(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!) { dataResut, error in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
            }
            else{
                self.performSegue(withIdentifier: "signedIn", sender: nil)
            }
        }
            
        }
        else {
            makeAlert(title: "Error", message: "You entered wrong formatted text!")
        }
    }
    @IBAction func RegisterButtonClicked(_ sender: Any) {
    }
    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert , animated: true, completion: nil)
    }

}

