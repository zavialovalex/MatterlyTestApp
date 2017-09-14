//
//  DateUtil.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import Foundation

struct DateUtil {
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy"
    }
    
    func currentYear()-> Float? {
        return Float(dateFormatter.string(from: Date()))
    }
    
    func currentYearString()-> String {
        return dateFormatter.string(from: Date())
    }
}
