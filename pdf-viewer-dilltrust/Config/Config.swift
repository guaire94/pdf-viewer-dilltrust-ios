//
//  Config.swift
//  Pdf-Viewer-Dilitrust
//
//  Created by Quentin Gallois on 28/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//


import UIKit

let SERVER_URL = "https://pdf-viewer-dilitrust.herokuapp.com/"

let shadowColor    = UIColor(netHex:0xD9E2E9)

public typealias SuccessAPI = (NSDictionary?) -> Void
public typealias FailureAPI = (NSDictionary?, _ code:Int?) -> Void
public typealias Completion = (NSDictionary, NSError) -> Void

