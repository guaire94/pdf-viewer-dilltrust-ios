//
//  File.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 29/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation
import RealmSwift

class File: Object{
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var url = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
}
