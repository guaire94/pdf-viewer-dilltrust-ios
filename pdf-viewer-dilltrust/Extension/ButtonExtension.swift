//
//  Extension.swift
//  GeolocalizationTest
//
//  Created by Quentin Gallois on 22/12/2016.
//  Copyright © 2016 Quentin Gallois. All rights reserved.
//

import Foundation
import UIKit
import AVKit

var TITLE = ""

extension UIButton {

    func loadingIndicator(show: Bool) {
        let tag = 1000
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            TITLE = self.title(for: .normal)!
            self.setTitle("", for: .normal)
            indicator.center = CGPoint(x:buttonWidth/2, y:buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                self.isEnabled = true
                self.setTitle(TITLE, for: .normal)
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
