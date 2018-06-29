//
//  ManagerUser.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation
import RealmSwift

class ManagerUser {
    static let sharedInstance = ManagerUser()
    
    var currentUser : User!
    
    public func clearUsers() {
        let realm = try! Realm()
        self.currentUser = nil
        let users = realm.objects(User.self)
        try! realm.write {
            if (users.count > 0) {
                realm.delete(users)
            }
        }
    }
    
    public func createUser(username:String, access_token:String) {
        let realm = try! Realm()
        self.clearUsers()
        
        let user = User()
        user.username = username
        user.access_token = access_token
        user.id = "..."
        user.email = "..."
        user.lastname = "..."
        user.firstname = "..."
        user.refresh_token = "..."
        try! realm.write {
            realm.add(user)
            self.currentUser = user
        }
    }
    
    public func updateUser(data:NSDictionary?) {
        let realm = try! Realm()
        
        var id              = "..."
        var email           = "..."
        var lastname        = "..."
        var firstname       = "..."
        var refresh_token   = "..."
        
        if let user = data?.object(forKey: "user") as? NSDictionary {
            if let tmp = user.object(forKey: "id") as? String { id = tmp }
            if let tmp = data?.object(forKey: "email") as? String { email = tmp }
            if let tmp = data?.object(forKey: "lastname") as? String { lastname = tmp }
            if let tmp = data?.object(forKey: "firstname") as? String { firstname = tmp }
            if let tmp = data?.object(forKey: "refreshToken") as? String { refresh_token = tmp }
        }

        try! realm.write {
            self.currentUser.id = id
            self.currentUser.email = email
            self.currentUser.lastname = lastname
            self.currentUser.firstname = firstname
            self.currentUser.refresh_token = refresh_token
        }
    }

    public func refreshToken(token:String) {
        let realm = try! Realm()
        
        try! realm.write {
            if (self.currentUser.isInvalidated == false) {
                self.currentUser.access_token = token
            }
        }
    }

    public func isUserExist() -> Bool {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        if users.count == 0 {
            return false
        }
        self.currentUser = users.first
        return true
    }

}
