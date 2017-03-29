//
//  ModelsManager.swift
//  Assignment1
//
//  Created by Roland Askew on 3/28/17.
//  Copyright © 2017 Unitec. All rights reserved.
//
//  managers to keep track of active models.
//

import Foundation

/***
 *   Manager class for Shape classes.
 *
 *   Singleton Pattern
 *
 *   Stores sequence of shapes. Ordered by time created.
 *   Acts as proxy to the storage sequence.
 *   Means models are always available from one and only one source, and always kept track of.
 */
class ShapeManager
{
	//MARK: singleton instance
	private
    static let instance = ShapeManager( )
	
	//MARK: variables
	var shapes = [ BaseShape ] ( )
	
	//MARK: constructor
	init( ) {
		// should have empty list of BaseShapes.
	}
	
	//MARK: singleton instance retrieval
	public 
	static func getInstance( ) -> ShapeManager
	{
		return instance
	}
	
	//MARK: methods
	func append( shape : BaseShape )
	{
		self .shapes .append( shape )
	}
	
	func removeLast( ) -> BaseShape
	{
		let shape = self .shapes .removeLast( )
		return shape
	}
	
	func count( ) -> Int
	{
		return self .shapes .count
	}
    
    func getShape( at index : Int) -> BaseShape
    {
        return self .shapes[ index ]
    }
    
    func removeAll( )
    {
        self .shapes .removeAll( )
    }
}

