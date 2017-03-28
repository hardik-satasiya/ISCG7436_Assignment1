//
//  ModelsManager.swift
//  Assignment1
//
//  Created by Roland Askew on 3/28/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation

/***
 *   Manager class for Shape classes.
 */
class ShapeManager
{
	//MARK: singleton instance
	private
    static let instance = ShapeManager()
	
	//MARK: variables
	var shapes = [BaseShape]()
	
	//MARK: constructor
	init() {
		// should have empty list of BaseShapes.
	}
	
	//MARK: singleton instance retrieval
	public 
	static func getInstance() -> ShapeManager
	{
		return instance
	}
	
	//MARK: methods
	func append( shape : BaseShape)
	{
		self.shapes.append(shape)
	}
	
	func removeLast( ) -> BaseShape
	{
		var shape = self.shapes.remove()
		return shape
	}
	
	func count() -> Int
	{
		return self.shapes.count
	}
}

