//
//  Tools.swift
//  Assignment1
//
//  Created by Roland Askew on 3/23/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation
import UIKit

enum Tools : Int {
    case pencil = 0
    case rectangle = 1
    case oval = 2
    case line = 3
    
    func getShapeforTool(origin point: CGPoint) -> BaseShape
    {
        switch self
        {
        case .pencil:
            return FreeformLineShape(initial: point)
            
        case .line:
            return LineShape(initial: point)
            
        case .rectangle:
            return RectangleShape(initial: point)
            
        case .oval:
            return OvalShape(initial: point)
        }
    }
}
