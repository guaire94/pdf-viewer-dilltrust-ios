//
//  Router.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation

// MARK: Router
public enum Router {
    
    static var baseURLString = "https://pdf-viewer-dilitrust.herokuapp.com/api/"
    
    // api calls
    case GET(path: String)
    case POST(path: String, parameters: String)
    case PUT(path: String, parameters: String)
    
    // api methods
    var method : String {
        switch self {
        case .POST:
            return "POST"
            
        case .PUT:
            return "PUT"
            
        case .GET:
            return "GET"
            
        }
    }
    
    // api paths
    var path: String {
        switch self {
            
        case .GET(path: let path):
            return path
            
        case .POST(path: let path, parameters: _):
            return path
            
        case .PUT(path: let path, parameters: _):
            return path
            
        }
    }
    
    // api url request
    public var requestURL: URLRequest {
        
        let url = URL(string: Router.baseURLString + path)!
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = method
        if ManagerUser.sharedInstance.currentUser != nil {
            if !ManagerUser.sharedInstance.currentUser.isInvalidated {
                request.setValue("\(ManagerUser.sharedInstance.currentUser.access_token)", forHTTPHeaderField: "Authorization")
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .GET(path: _):
            return request
            
        case .POST(path: _, parameters: let parameters):
            let body = parameters.data(using: String.Encoding.utf8)
            request.httpBody = body
            return request

        case .PUT(path: _, parameters: let parameters):
            let body = parameters.data(using: String.Encoding.utf8)
            request.httpBody = body
            return request
        }
    }
    
}


