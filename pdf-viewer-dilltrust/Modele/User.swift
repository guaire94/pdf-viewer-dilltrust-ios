//
//  User.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    @objc dynamic var id = ""
    @objc dynamic var username = ""
    @objc dynamic var email = ""
    @objc dynamic var lastname = ""
    @objc dynamic var firstname = ""
    @objc dynamic var access_token = ""
    @objc dynamic var refresh_token = ""
}
