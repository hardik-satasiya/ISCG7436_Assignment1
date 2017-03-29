//
//  Models.swift
//  Assignment1
//
//  Created by Roland Askew on 3/23/17.
//  Copyright © 2017 Unitec. All rights reserved.
//
//  Models specific to the project.
//
//

import Foundation
import UIKit

/***
 *   Base class for Shape classes.
 */
class BaseShape
{
    // the first point in the path
    // different for open shapes (lines), and closed shapes
    func getOrigin() -> CGPoint
    {
        preconditionFailure("Must override in subclass.")
    }
    
    // how to draw the shape.
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
    
    override func getOrigin() -> CGPoint {
        return self.linePath[0]
    }
    
    // specific only to single straight lines
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
    
    // specific only to freeform lines
    public final
    func addPoint(next point: CGPoint) {
        self.linePath.append(point)
    }
}

/***
 *   Represent a rectangle or square
 */
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
    
    override func getOrigin() -> CGPoint {
        return CGPoint(x : self.x, y : self.y)
    }
    
    // will always treat origin as top left corner.
    func setSize( size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    // more useful when working with transitions.
    func setSize( width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
    }
    
    // convenience method, as subclasses use the same rect shape for drawing
    func getRectPath() -> CGRect
    {
        let rect = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
        return rect
    }
    
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( rect: self.getRectPath())
    }
}

/***
 *   Represent an Oval (use rectangle to draw within).
 */
class OvalShape : RectangleShape {
    override func getShapePath() -> UIBezierPath {
        return UIBezierPath( ovalIn: self.getRectPath())
    }
}
