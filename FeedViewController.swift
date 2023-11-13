//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Alim Gönül on 4.05.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    var userEmailArray = [String]()
    var userCommnetArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
        getDataFromFireStore()
    }
    // FİREBASE'DEN VERİLERİ ÇEKİYORUZ
    func getDataFromFireStore() {
        let fireStoreDatabase = Firestore.firestore()
        // Descending kısmını sonradan ekledik feed'te tarihe göre resim sıralıyor
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommnetArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let commnet = document.get("postComment") as? String {
                            self.userCommnetArray.append(commnet)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        // resmi Feed'te göstermek için yeni bir kütüphane kullandık ==> SDWEbimage
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.commentLabel.text = userCommnetArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        return cell
    }
}
