//
//  DateExtension.swift
//  pdf-viewer-dilltrust
//
//  Created by Quentin Gallois on 29/06/2018.
//  Copyright © 2018 Quentin Gallois. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"        
        return formatter
    }()
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
