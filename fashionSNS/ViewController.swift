import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    // ログイン用のUITextFieldです
    @IBOutlet var loginMailTextField: UITextField!
    @IBOutlet var loginPasswordTextField: UITextField!
    // 新規登録用のUITextFieldです
    @IBOutlet var signUpNameTextField: UITextField!
    @IBOutlet var signUpMailTextField: UITextField!
    @IBOutlet var signUpPassowordTextField: UITextField!
    @IBOutlet var signUpPasswordConfirmationTextField: UITextField!
 



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginMailTextField.text = ""
        loginPasswordTextField.text = ""
        signUpNameTextField.text = ""
        signUpMailTextField.text = ""
        signUpPassowordTextField.text = ""
        signUpPasswordConfirmationTextField.text = ""
    }
    
    @IBAction func registerButton() {
        let name = signUpNameTextField.text ?? ""
        let email = signUpMailTextField.text ?? ""
        let password = signUpPassowordTextField.text ?? ""
        let passwordConfirmation = signUpPasswordConfirmationTextField.text ?? ""
        
        if (password == passwordConfirmation) {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if (result?.user) != nil {
                    self.saveUserData(email: email, name: name)
                    print("新規登録成功！")
                    self.performSegue(withIdentifier: "ToTopView", sender: nil)
                } else {
                    print(error!)
                }
            }
        }
    }
    
    @IBAction func loginButton() {
        let email = loginMailTextField.text ?? ""
        let password = loginPasswordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if (result?.user) != nil {
                self.performSegue(withIdentifier: "ToTopView", sender: nil)
            } else {
                print(error!)
            }
        }
    }
    
    func saveUserData(email: String?, name: String?) {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid ?? "uid:Error").setData([
                "uid": uid ?? "uid:Error",
                "email": email ?? "email:Error",
                "name": name ?? "name:Error",
        ])
    }


}
