//
//  ListTableViewCell.swift
//  fashionSNS
//
//  Created by 竹田珠子 on 2023/01/15.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var image2view: UIImageView!
    @IBOutlet var nicebutton: UIButton!
    
    
    @IBAction func nicebuttonTapped(){
        let docId: String = "\(nicebutton.layer.name!)"
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        if  nicebutton.backgroundColor == UIColor.gray {
            nicebutton.backgroundColor = UIColor.blue
            let docId: String = "\(nicebutton.layer.name)" //ドキュメントIdをTagから取得
            let db = Firestore.firestore() // Firestoreのdb作成
            let uid = Auth.auth().currentUser?.uid // ユ
            db.collection("users").document(uid ?? "uid:Error")
                .collection("nicePosts").document(docId ?? "default").setData([
                    "postId": docId ?? "postId:Error"
                ])
        }
        else if nicebutton.backgroundColor == UIColor.blue {
            nicebutton .backgroundColor = UIColor.gray
            db.collection("users").document(uid ?? "uid:Error")
                .collection("nicePosts").document(docId ?? "default").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            
        }
    }
        
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.isScrollEnabled = false
        // Initialization code
        nicebutton.backgroundColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // ListViewController.swift


        // コード
    }

