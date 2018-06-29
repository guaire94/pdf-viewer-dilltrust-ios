//
//  AnimateLaunchScreen.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit
import RealmSwift

class AnimateLaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loading.startAnimating()
        self.isUserAlreadyConnect()
    }
    
    func isUserAlreadyConnect() {
        if ManagerUser.sharedInstance.isUserExist() {
            fetchProfile()
        }
        else {
            let accountSB = UIStoryboard(name: "Account", bundle: nil)
            let accountViewController = accountSB.instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = accountViewController
            appDelegate.window?.makeKeyAndVisible()
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
                self.loading.stopAnimating()
                let accountSB = UIStoryboard(name: "Account", bundle: nil)
                let accountViewController = accountSB.instantiateInitialViewController()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = accountViewController
                appDelegate.window?.makeKeyAndVisible()
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
