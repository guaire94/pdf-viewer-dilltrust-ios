//
//  API.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//


import Foundation

// MARK: API Class
public class API {
    
    enum Method{
        //USER
        case login
        case user
        case refresh

        //FILES
        case files

        func url() -> String{
            switch self {
            //USER
            case .login:
                return "user/login"
            case .user:
                return "user"
            case .refresh:
                return "user/refresh"
                
            //FILES
            case .files:
                return "file"
            }
        }
    }

    public class func setBaseUrl(url: String) {
        Router.baseURLString = url
    }

    /**
     Call a given request and execute success/failure closure once request is done.
     - parameter request: URLRequestConvertible with a given path.
     - parameter success: a Success closure to launch after the api succeeds.
     - parameter failure: a Failure closure to launch after the api fails.
     */
    public class func call(request: Router, returnsData:Bool? = true, success: SuccessAPI?, failure: FailureAPI?) {
        print("URL = \(request.requestURL) (\(request.method))")
        
        let session = URLSession.shared
        session.dataTask(with: request.requestURL){ (data, response, error) -> Void in
            guard let httpResponse = response as? HTTPURLResponse else { failure?([:], 500); return }
            print(httpResponse.statusCode)
            
            if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                let jsonResult = self.dataToJSON(data: data!)
                success?(jsonResult)
            }
            else if (httpResponse.statusCode == 204) {
                success?([:])
            }
            else if (httpResponse.statusCode == 401) {
                self.askRefresh(completionHandler: { (refreshSuccess:Bool) in
                    if refreshSuccess {
                        self.call(request: request, success: { (data) in
                            success?(data)
                        }, failure: { (data, error) in
                            failure?(data, 500)
                        })
                    }
                    else {
                        failure?([:], 403)
                    }
                })
            }
            else {
                failure?([:], 500)
            }

        }.resume()
    }
   
    /*
     REFRESH TOKEN if REQUEST.StatusCode == 401
     */
    private class func askRefresh(completionHandler:@escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            let session = URLSession.shared
            
            let params = "{\"access_token\": " + ManagerUser.sharedInstance.currentUser.access_token + "\", \"refresh_token\": \"" + ManagerUser.sharedInstance.currentUser.refresh_token + "\"}"
            let request = Router.POST(path: API.Method.refresh.url(), parameters: params)
            session.dataTask(with: request.requestURL){ (data, response, error) -> Void in
                guard let httpResponse = response as? HTTPURLResponse else { completionHandler(false); return }
                print(httpResponse.statusCode)
                if (httpResponse.statusCode ==  201) {
                    let jsonResult = self.dataToJSON(data: data!)
                    guard let token = jsonResult.object(forKey: "jwt") as? String else { completionHandler(false); return }
                    DispatchQueue.main.async {
                        ManagerUser.sharedInstance.refreshToken(token: token)
                        completionHandler(true)
                    }
                }
                else {
                    completionHandler(false)
                }
                }.resume()
        }
    }
    
    public class func dataToJSON(data:Data) -> NSDictionary {
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                return jsonResult
            }
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary] {
                if jsonResult.count != 1 {
                    return [:]
                }
                return jsonResult.first!
            }

        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return [:]
    }

}
