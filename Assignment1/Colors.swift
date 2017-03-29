//
//  Colors.swift
//  Assignment1
//
//  Created by Roland Askew on 3/23/17.
//  Copyright © 2017 Unitec. All rights reserved.
//
//  enums for color selection and CGColor retrieval
//
//

import Foundation
import UIKit

enum Colors : Int {
    case red = 0
    case yellow = 1
    case green = 2
    case blue = 3
    case purple = 4
    
    func getColor () -> CGColor {
        switch self {
        case .red:
            return UIColor.red.cgColor
        case .yellow:
            return UIColor.yellow.cgColor
        case .green:
            return UIColor.green.cgColor
        case .blue:
            return UIColor.blue.cgColor
        case .purple:
            return UIColor.purple.cgColor
            
        }
    }
}
