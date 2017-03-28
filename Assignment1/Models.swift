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
    var x : CGFloat = 0
    var y : CGFloat = 0
    var width: CGFloat = 0
    var height : CGFloat = 0
    
    init(initial point: CGPoint)
    {
        self.x = point.x
        self.y = point.y
    }
    
    func setSize( size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    func setSize( width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    // convenience method, as subclasses use the same rect shape for drawing
    func getRectPath() -> CGRect
    {
        return CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
    }
    
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( rect: self.getRectPath())
    }
}

class OvalShape : RectangleShape {
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( ovalIn: self.getRectPath())
    }
}
