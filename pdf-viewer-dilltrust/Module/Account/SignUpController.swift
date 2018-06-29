//
//  SignUpViewController.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextToggle(_ sender: UIButton) {
        self.doneButton.loadingIndicator(show: true)
        if (self.txtFieldUsername.text! == "") {
            self.showAlert(title: "Verify form", message: "Username is empty")
        }
        else if (self.txtFieldPassword.text! == "") {
            self.showAlert(title: "Verify form", message: "Password is empty")
        }
        else if (self.txtFieldEmail.text! == "") {
            self.showAlert(title: "Verify form", message: "Email is empty")
            return
        }
        else if ((self.txtFieldPassword.text?.count)! < 6) {
            self.showAlert(title: "Verify form", message: "Password too short")
        }
        else if (self.txtFieldEmail.text?.isValidEmail == false) {
            self.showAlert(title: "Verify form", message: "Email is invalid")
        }
        else {
            let params = "{\"username\": \"" + self.txtFieldUsername.text! + "\", \"password\": \"" + self.txtFieldPassword.text! + "\", \"email\": \"" + self.txtFieldEmail.text! + "\"}"
            API.call(request: Router.POST(path: API.Method.user.url(), parameters: params), returnsData: true,
                     success: { (data) in
                        DispatchQueue.main.async {
                            self.fetchLogin()
                        }
            })
            { (data, statutCode) in
                DispatchQueue.main.async {
                    self.doneButton.loadingIndicator(show:false)
                    self.showError()
                }
            }
        }
    }
    
    func fetchLogin() {
        let params = "{\"username\": \"" + self.txtFieldUsername.text! + "\", \"password\": \"" + self.txtFieldPassword.text! + "\"}"
        API.call(request: Router.POST(path: API.Method.login.url(), parameters: params), returnsData: true,
                 success: { (data) in
                    DispatchQueue.main.async {
                        guard let access_token = data?.object(forKey: "token") as? String else { return }
                        ManagerUser.sharedInstance.createUser(username: self.txtFieldUsername.text!, access_token: access_token)
                        self.fetchProfile()
                    }
        })
        { (data, statutCode) in
            DispatchQueue.main.async {
                self.doneButton.loadingIndicator(show:false)
                self.showError()
            }
        }
    }
    
    func fetchProfile() {
        API.call(request: Router.GET(path: API.Method.user.url()), returnsData: true,
                 success: { (data) in
                    DispatchQueue.main.async {
                        ManagerUser.sharedInstance.updateUser(data: data)
                        self.fetchProfileDone()
                    }
        })
        { (data, statutCode) in
            DispatchQueue.main.async {
                self.doneButton.loadingIndicator(show:false)
                self.showError()
            }
        }
        
    }
    
    func fetchProfileDone() {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let filesViewController = mainSB.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = filesViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func backToggle(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 , execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SignUpViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
