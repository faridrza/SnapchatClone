//
//  signUpVC.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 21.01.22.
//

import UIKit
import Firebase

class signUpVC: UIViewController {

    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func RegisterButtonClicked(_ sender: Any) {
        if usernameTxtField.text != "" && emailTxtField.text != "" && passwordTxtField.text != "" {
            Auth.auth().createUser(withEmail: self.emailTxtField.text!, password: self.passwordTxtField.text!) { data, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ??  "Error")
                }
                else{
                    let firestore = Firestore.firestore()
                    let userInfoDictionary = ["username" : self.usernameTxtField.text, "userEmail" : self.emailTxtField.text]
                    firestore.collection("UserInfo").addDocument(data: userInfoDictionary as [String : Any]) { error in
                        if error != nil {
                            self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                        }
                        else{
                            self.performSegue(withIdentifier: "toTabBar", sender: nil)
                        }
                    }
                }
            }
        }
        else{
            makeAlert(title: "Error", message: "You can not leave this space empty!")
        }
        
    }
    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert , animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
