//
//  AccountViewController.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginToggle(_ sender: UIButton) {
        self.btn_login.loadingIndicator(show:true)
        let params = "{\"username\": \"" + txtFieldUsername.text! + "\", \"password\": \"" + txtFieldPassword.text! + "\"}"
        
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
                self.btn_login.loadingIndicator(show:false)
                self.showAlert(title: NSLocalizedString("failed_server", comment: ""),
                               message: NSLocalizedString("check_your_ids", comment: ""))
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
                self.btn_login.loadingIndicator(show:false)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AccountViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

