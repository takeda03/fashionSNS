//
//  PostViewController.swift
//  fashionSNS
//
//  Created by 竹田珠子 on 2023/01/15.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import AVFoundation
class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var photoimageView: UIImageView!
    
    let storage = Storage.storage()
    var image : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleTextField.text = ""
        contentTextView.text = ""
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
    @IBAction func backButton(){
        dismiss(animated: true,completion: nil)
        
    
    }

    @IBAction func postButton() {
            if(titleTextField.text != "" && contentTextView.text != ""){
                // ドキュメントを設定する
            var ref: DocumentReference? = nil
                ref = Firestore.firestore().collection("posts").addDocument(data: [
                    "title": titleTextField.text ?? "title:Error",
                    "content": contentTextView.text ?? "content:Error",
                    "uid": Auth.auth().currentUser?.uid ?? "uid:Error",
                    "created_at": Date(),
                ]) { [self] err in
              if let err = err {
                print("Error writing document: \(err)")
              } else {
                print("Document added with ID: \(ref!.documentID)")
                  let storageRef = self.storage.reference()
                        
                        // Data in memory
                        guard let data = image.pngData() else {
                            return
                        }
                        
                        // Create a reference to the file you want to upload
                        let testRef = storageRef.child("images/\(ref!.documentID)jpg")
                        
                        // Upload the file to the path "images/rivers.jpg"
                        let uploadTask = testRef.putData(data, metadata: nil) { (metadata, error) in
                          guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                              print("error!",error)
                            return
                          }
                          // Metadata contains file metadata such as size, content-type.
                          let size = metadata.size
                          // You can also access to download URL after upload.
                          testRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                              // Uh-oh, an error occurred!
                                print("error!",error)
                              return
                            }
                              // ドキュメントを上書きする
                              Firestore.firestore().collection("posts").document("\(ref!.documentID)").updateData([
                            "url": url
                          ]) { err in
                            if let err = err {
                              print("Error updating document: \(err)")
                            } else {
                              print("Document successfully written!")
                            }
                          }
                          }
                        }
               }
            }
            } else {
                let alert = UIAlertController(title: "注意", message: "入力されていない項目があります", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true, completion: nil)
            }
        }

    // storageにupload
               
        
        
        // MARK: カメラを起動
        @IBAction func cameraButton(){
           
            let alert: UIAlertController = UIAlertController(title: "プロフィールを設定", message: "どちらから設定しますか？", preferredStyle:  UIAlertController.Style.actionSheet)
            
            //カメラを起動するアラート
            let cameraAction: UIAlertAction = UIAlertAction(title: "カメラを起動", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
                self.cameraAuth(vc: UIViewController(), completion: {_ in print("OK")})
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                // UIImagePickerController カメラを起動する
                self.present(picker, animated: true, completion: nil)
                
                print("カメラを起動")
            })
            //フォトライブラリを起動するコード
            let photoAction: UIAlertAction = UIAlertAction(title: "フォトライブラリを起動", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
                let picker = UIImagePickerController()
                self.present(picker, animated: true)
                
                //画像選択時のデリゲートを設定
                picker.delegate = self
                print("フォトライブラリを起動")
            })
            
            // Cancelボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("cancelAction")
            })
            
            //　アクションを追加
            alert.addAction(cameraAction)
            alert.addAction(photoAction)
            
            // アラートを表示
            present(alert, animated: true, completion: nil)
            
            
        }
        
    }

    extension PostViewController {
        
        //カメラ呼び出し後の処理
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             image = info[.originalImage] as! UIImage

            //imageViewに画像を表示
           photoimageView.image = image
            // UIImagePickerController カメラが閉じる
            self.dismiss(animated: true, completion: nil)
        }
        
        
        //フォトライブラリ起動後の処理
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
            // 画像選択時の処理
            // ↓選んだ画像を取得
            image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            
 
            //カメラロールを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // キャンセルボタンを押下時の処理
            //カメラロールを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }



extension PostViewController {
    
    // カメラ許可コード
    func cameraAuth(
        vc: UIViewController,
        mediaType: AVMediaType = .video,
        title: String = "カメラを使用します",
        message: String = "カメラの使用が許可されていません。プライバシー設定でカメラの使用を許可してください",
        completion: @escaping (Bool) -> Void)
    {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied:
            // ユーザがカメラへのアクセスを拒否した
            dialogForConfiguration(vc: vc, title: title, message: message, completion: completion)
        case .restricted:
            // システムによってカメラへのアクセスが拒否された。
            // カメラが存在しない場合も多分ここ
            dialogForConfiguration(vc: vc, title: title, message: message, completion: completion)
        }
    }
    
    // カメラへのアクセスを許可するようユーザに促す
    private func dialogForConfiguration(
        vc: UIViewController,
        title: String,
        message: String?,
        completion: @escaping (Bool) -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion(false)
        }
        alertController.addAction(okAction)
        let settingsAction = UIAlertAction(title: "設定", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)
            UIApplication.shared.open(url!, options: [:]) { _ in
                completion(false)
            }
        }
        alertController.addAction(settingsAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}



