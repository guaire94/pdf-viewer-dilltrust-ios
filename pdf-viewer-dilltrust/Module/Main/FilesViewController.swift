//
//  AccountViewController.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit

class FileCell : UITableViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(withFile file: File) {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.content.layer.shadowColor = shadowColor.cgColor
        self.content.layer.shadowOpacity = 1
        self.content.layer.shadowOffset = CGSize.zero
        self.content.layer.shadowRadius = 2
        self.content.layer.cornerRadius = 5

        if (file.type == ".pdf") {
            self.typeImageView.image = #imageLiteral(resourceName: "pdf_file")
        }
        else {
            self.typeImageView.image = #imageLiteral(resourceName: "unknow_file")
        }
        self.nameLabel.text = file.name.capitalizingFirstLetter()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_EN")
        dateFormatter.dateFormat = "MMMM dd, yyyy - h:mm a"
        
        self.createdAtLabel.text = dateFormatter.string(from: file.createdAt)

    }
    
}

class FilesViewController: UIViewController {
        
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var filesTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var files = [File]()
    var selectedFile = File()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.fetchFiles()
    }
    
    func configView() {
        self.helloLabel.text = "Hello " + ManagerUser.sharedInstance.currentUser.username.capitalizingFirstLetter()
    }
    
    func fetchFiles() {
        self.loading.startAnimating()
        API.call(request: Router.GET(path: API.Method.files.url()), returnsData: true,
                 success: { (data) in
                    DispatchQueue.main.async {
                        guard let files = data?.object(forKey: "files") as? [NSDictionary] else { return }
                        ManagerFile.sharedInstance.createFiles(files: files)
                        self.fetchFilesDone()
                    }
        })
        { (data, statutCode) in
            self.loading.stopAnimating()
            self.showError()
        }
    }
    
    func fetchFilesDone() {
        self.files = ManagerFile.sharedInstance.getFiles()
        self.loading.stopAnimating()
        self.filesTableView.reloadData()
    }
    
    @IBAction func logoutToggle(_ sender: UIButton) {
        ManagerUser.sharedInstance.clearUsers()
        let accountSB = UIStoryboard(name: "Account", bundle: nil)
        let accountViewController = accountSB.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = accountViewController
        appDelegate.window?.makeKeyAndVisible()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FileViewerViewControllerSegue" {
            guard let vc = segue.destination as? FileViewerViewController else { return }
            vc.file = self.selectedFile
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:FileCell = tableView.dequeueReusableCell(withIdentifier: "FileCell")
            as? FileCell else { return UITableViewCell() }
        let file = self.files[indexPath.row]
        cell.configure(withFile: file)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFile = self.files[indexPath.row]
        self.performSegue(withIdentifier: "FileViewerViewControllerSegue", sender: self)
    }
    
}

