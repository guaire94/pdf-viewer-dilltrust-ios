//
//  ManagerFile.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 29/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation
import RealmSwift

class ManagerFile {
    static let sharedInstance = ManagerFile()
    
    var currentUser : User!
    
    public func clearFiles() {
        let realm = try! Realm()
        let files = realm.objects(File.self)
        try! realm.write {
            if (files.count > 0) {
                realm.delete(files)
            }
        }
    }
    
    public func createFiles(files:[NSDictionary]) {
        let realm = try! Realm()
        self.clearFiles()
        
        for file in files {
            var id          = "..."
            var name        = "..."
            var type        = "..."
            var url         = "..."
            var createdAt   = Date()
            var updateAt   = Date()
            
            if let tmp = file.object(forKey: "id") as? String { id = tmp }
            if let tmp = file.object(forKey: "name") as? String { name = tmp }
            if let tmp = file.object(forKey: "type") as? String { type = tmp }
            if let tmp = file.object(forKey: "url") as? String { url = tmp }
            if let tmp = file.object(forKey: "createdAt") as? String {
                if let datestring = tmp.dateFromISO8601 {
                    createdAt = datestring
                }
            }
            if let tmp = file.object(forKey: "updateAt") as? String {
                if let datestring = tmp.dateFromISO8601 {
                    updateAt = datestring
                }
            }

            let newFile = File()
            newFile.id = id
            newFile.name = name
            newFile.type = type
            newFile.url = url
            newFile.createdAt = createdAt
            newFile.updatedAt = updateAt
            
            try! realm.write {
                realm.add(newFile)
            }

        }
    }

    public func getFiles() -> [File] {
        let realm = try! Realm()
        let files = realm.objects(File.self)
        return Array(files)
    }
}
