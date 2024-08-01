//
//  ViewController.swift
//  WarCards
//
//  Created by Chethan Nayak  on 01/08/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Playername: UITextField!
    @IBOutlet weak var PlayWarCard: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Playername.becomeFirstResponder()
        Playername.delegate = self
        // Do any additional setup after loading the view.
    }
    
    public class UserManager {
        static let shared = UserManager()
        var username: String?

        private init() {}
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
        guard unwantedStr.isEmpty else { return false }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
    func validateInputField(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? true {
            // Show an error message or alert
            print("Please enter a Username")
            let alert = UIAlertController(title: "Please Enter PlayerName", message: "", preferredStyle: .alert)
            
//            let quitAction = UIAlertAction(title: "Quit", style: .destructive) { _ in
//                print("Exited")
//                exit(0)
//            }
            
            let cancelAction = UIAlertAction(title: "Enter PlayerName", style: .cancel) { _ in
                self.Playername.becomeFirstResponder()
            }
            
//            alert.addAction(quitAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    @IBAction func PlayGame(_ sender: Any) {
        if validateInputField(Playername) {
            UserManager.shared.username = Playername.text
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MainGameViewController") as! MainGameViewController
            vc.username = UserManager.shared.username // Pass the username to the next VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

