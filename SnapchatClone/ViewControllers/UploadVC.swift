//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 21.01.22.
//

import UIKit
import Firebase

class UploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        image.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        image.addGestureRecognizer(gestureRecognizer)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func imageClicked(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImages = info[.editedImage]
        image.image = (chosenImages as! UIImage)
        self.dismiss(animated: true)
    }
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        let uuid = UUID().uuidString
        let imageRef = mediaFolder.child("\(uuid).jpg")
        let imageData = (image.image?.jpegData(compressionQuality: 0.3))!
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else{
                imageRef.downloadURL { url, error in
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    }
                    else{
                        if let imageUrl = url?.absoluteString {
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("snaps").whereField("username", isEqualTo: UserInfoSingleton.SharedUserInfo.KeptUsername).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Server error")
                                }
                                else if snapshot != nil && snapshot?.isEmpty == false {
                                    for document in snapshot!.documents {
                                        let documentID = document.documentID
                                        if var urlArray = document.get("urlArray") as? [String] {
                                            urlArray.append(imageUrl)
                                            let mergedUrlArray = ["urlArray" : urlArray] as [String : Any]
                                            firestore.collection("snaps").document(documentID).setData(mergedUrlArray, merge: true) { error in
                                                if error != nil {
                                                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "Server error")
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                else{
                                    let snapData = ["urlArray" : [imageUrl], "userEmail" : Auth.auth().currentUser?.email! as Any, "username" : UserInfoSingleton.SharedUserInfo.KeptUsername, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                    firestore.collection("snaps").addDocument(data: snapData) { error in
                                        if error != nil {
                                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error" )
                                        }
                                }
                            }
                            
                            }
                        }
                    }
                }
            }
        }
        
    }
    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert , animated: true, completion: nil)
    }
   
}
