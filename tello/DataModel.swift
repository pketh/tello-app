//
//  DataModel.swift
//  tello
//
//  Created by Pirijan on 2014-09-19.
//  Copyright (c) 2014 pketh. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Model Objects

class User: NSManagedObject {
	@NSManaged var name: String
	@NSManaged var url: String
	@NSManaged var avatarHash: String
	@NSManaged var boards: NSSet
	// password stored in keychain: http://josebolanos.wordpress.com/2012/03/16/core-data-passwords-in-keychain/
}

class Board: NSManagedObject {
	@NSManaged var boardColor: String
	@NSManaged var boardCustomBackground: NSData
	@NSManaged var boardID: String
	@NSManaged var boardName: String
	@NSManaged var lists: NSSet
	@NSManaged var user: tello.User
}

class List: NSManagedObject {
	@NSManaged var listID: String
	@NSManaged var listName: String
	@NSManaged var board: tello.Board
}

class CardQueue: NSManagedObject {
	@NSManaged var boardID: String
	@NSManaged var listID: String
	@NSManaged var newCard: String
}
