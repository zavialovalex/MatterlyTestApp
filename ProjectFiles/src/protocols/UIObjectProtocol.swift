//
//  UIObjectProtocol.swift
//  Matterly Test App
//
//  Created by User on 9/13/17.
//  Copyright © 2017 Olearis. All rights reserved.
//

import UIKit

protocol UIObjectProtocol: class {
    
    static var identifier: String { get }
    
    static var nibFile: UINib? { get }
}
