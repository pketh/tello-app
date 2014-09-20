//
//  DataModel.swift
//  tello
//
//  Created by Pirijan on 2014-09-19.
//  Copyright (c) 2014 pketh. All rights reserved.
//

import Foundation

// MARK: - Model Objects

class Board: NSManagedObject {
	@NSManaged var boardID: String
	@NSManaged var boardName: String
	@NSManaged var boardColor: String
	@NSManaged var boardCustomBackground: NSData
	@NSManaged var lists: NSSet
}

class List: NSManagedObject {
	@NSManaged var listID: String
	@NSManaged var listName: String
	@NSManaged var board: Board
}

class CardQueue: NSManagedObject {
	@NSManaged var boardID: String
	@NSManaged var listID: String
	@NSManaged var newCard: String
}
