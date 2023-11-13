//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Alim Gönül on 4.05.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        
        // 3.ADIM UPLOAD BÖLÜMÜ
        super.viewDidLoad()
        // KULLANICININ GALERİSİNE GİDİYORUZ
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosenImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    // Kullanıcının galerisine gidiyoruz
    @objc func choosenImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    func makeAlert(titleInput:String ,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func UploadButtonClicked(_ sender: Any) {
        //  Yüklenen verileri Storage diye bir değişken oluşturup Firebase'ye yüklüyoruz.
        let storage = Storage.storage()
        let storagaReference = storage.reference()
        // Media diye bir folder oluşturuyoruz.
        let mediaFolder = storagaReference.child("Media")

        // Resmi kaydetmek için dataya çevirmemiz gerekiyor
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            // DATABASE
                            
                            let db = Firestore.firestore()
                            var ref : DocumentReference? = nil
                            
                            let fireStorePost = ["imageUrl": imageUrl!, "postedBy":Auth.auth().currentUser!.email!, "postComment": self.commentText.text!, "date":FieldValue.serverTimestamp(),"likes": 0] as [String: Any]
                            
                            ref = db.collection("Posts").addDocument(data: fireStorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput:"Error!", messageInput: error?.localizedDescription ?? "Error")
                                }
                                else {
                                    // eğer bi hata yoksa
                                    self.imageView.image = UIImage(named: "select-2")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
                
            }
            
            
        }
        
    }
}
