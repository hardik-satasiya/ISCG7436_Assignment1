//
//  Models.swift
//  Assignment1
//
//  Created by Roland Askew on 3/23/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation
import UIKit

/***
 *   Base class for Shape classes.
 */
class BaseShape
{
    func getShapePath() -> UIBezierPath
    {
        preconditionFailure("Must override in subclass.")
    }
}


/***
 *   Represents a single line
 */
class LineShape : BaseShape {
    var linePath = [CGPoint]()
    
    init(initial point: CGPoint)
    {
        self.linePath.append(point)
    }
    
    public final
    func setEndPoint( next point: CGPoint)
    {
        if self.linePath.count == 1
        {
            self.linePath.append(point)
        }
        else if self.linePath.count >= 2
        {
            self.linePath[1] = point
        }
    }
    
    override func getShapePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: self.linePath[0])
        
        let pathsize = self.linePath.count - 1
        for point in self.linePath[1...pathsize]
        { 
            path.addLine(to: point)
            path.move(to: point)
        }
        
        return path
    }
}

/***
 *   Represent a freeform line
 */
class FreeformLineShape : LineShape {
    
    public final
    func addPoint(next point: CGPoint) {
        self.linePath.append(point)
    }
}

class RectangleShape : BaseShape {
    var origin = CGPoint()
    var size = CGSize()
    
    init(initial point: CGPoint)
    {
        self.origin = point
    }
    
    func setSize( size: CGSize) {
        self.size = size
    }
    
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( rect: CGRect( origin: self.origin, size: self.size))
    }
}

class OvalShape : RectangleShape {
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( ovalIn: CGRect( origin: self.origin, size: self.size))
    }
}
