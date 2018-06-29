//
//  AccountViewController.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import UIKit
import PDFKit

class FileViewerViewController: UIViewController {
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pdfViewer: PDFView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var file = File()
    var document = PDFDocument()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.fetchPDF()
    }
    
    func configView() {
        self.nameLabel.text = file.name.capitalizingFirstLetter()
        self.pdfViewer.displayMode = .singlePageContinuous
        self.pdfViewer.displayDirection = .vertical
        self.pdfViewer.autoScales = true
    }
    
    func fetchPDF() {
        guard let url = URL(string: SERVER_URL + file.url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(ManagerUser.sharedInstance.currentUser.access_token, forHTTPHeaderField: "Authorization")
        self.loading.startAnimating()
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.loading.stopAnimating()
                    guard let tmp = PDFDocument(data: data!) else { return }
                    self.document = tmp
                    self.pdfViewer.document = self.document
                }
            }
        })
        task.resume()
    }

    
    @IBAction func shareToggle(_ sender: Any) {
        guard let data = self.document.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func backToggle(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
