//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 21.01.22.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var snapArray = [Snap]()
    var chosenSnapTimeLeft : Int?
    var chosenSnap : Snap?

    @IBOutlet weak var FeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        getSnapsFromFirebase()
        FeedTableView.delegate = self
        FeedTableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    func getSnapsFromFirebase() {
        let firestore = Firestore.firestore()
        firestore.collection("snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Server Error!")
            }
            else if snapshot?.isEmpty == false && snapshot != nil {
                self.snapArray.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let documentID = document.documentID
                    if let username = document.get("username") {
                        if let urlArray = document.get("urlArray") as? [String]{
                            if let date = document.get("date") as? Timestamp {
                                
                                if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                    if difference >= 24 {
                                        firestore.collection("snaps").document(documentID).delete()
                                    }
                                    else {
                                        
                                        self.chosenSnapTimeLeft = 24 - difference
                                        let newSnap = Snap(feedUsername: username as! String, feedUrlArray: urlArray, date: date.dateValue(), updatedTime: 24-difference)
                                        self.snapArray.append(newSnap)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                self.FeedTableView.reloadData()
            }
            else {
                self.makeAlert(title: "NO WAY!", message: " This place so quiet! Be a first!")
            }
        }
    }
    func getUserInfo() {
        let firestore = Firestore.firestore()
        firestore.collection("UserInfo").whereField("userEmail", isEqualTo: Auth.auth().currentUser?.email as Any).getDocuments { snapshot, error in
            if error != nil {self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")}
            else {
                if snapshot != nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents{
                        if let username = document.get("username"){
                            UserInfoSingleton.SharedUserInfo.KeptEmail = (Auth.auth().currentUser?.email!)! as String
                            UserInfoSingleton.SharedUserInfo.KeptUsername = username as! String
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = FeedTableView.dequeueReusableCell(withIdentifier: "cell") as! CellVC
        prototypeCell.usernameLabel.text = snapArray[indexPath.row].feedUsername
        prototypeCell.feedImage.sd_setImage(with: URL(string: "\(snapArray[indexPath.row].feedUrlArray[0])"))
        return prototypeCell
    }

    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert , animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenSnap = snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SnapVC
        destinationVC.time = chosenSnapTimeLeft
        destinationVC.snaps = chosenSnap
        
        }
}


