//
//  TopViewController.swift
//  fashionSNS
//
//  Created by 竹田珠子 on 2022/12/11.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TopViewController: UIViewController {
    
    @IBOutlet var loginMailLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    
    
    
    var loginMailText = ""
    var    loginNameText = ""
    
    var uid = Auth.auth().currentUser?.uid
    var listener: ListenerRegistration?

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginMailText = Auth.auth().currentUser?.email ?? "エラー"
        loginMailText += "さんでログイン中"
        loginMailLabel.text = loginMailText
        
        
    }
    @IBAction func logoutbutton(){
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error)
            }
        
    }
    func readUserData(uid: String) {
            let db = Firestore.firestore()
            listener = db.collection("users").whereField("uid", isEqualTo: uid).addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    print("Error!:", error)
                } else {
                    print("success!")
                    if let documentSnapshots = documentSnapshot?.documents {
                        for document in documentSnapshots {
                            let data = document.data()
                            self.loginNameText = data["name"] as? String ?? "Name:Error"
                            self.loginNameLabel.text = self.loginNameText
                        }
                    }
                }
            }
        }
        }

