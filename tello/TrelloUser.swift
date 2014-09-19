//
//  TrelloUser.swift
//  tello
//
//  Created by Pirijan on 2014-09-18.
//  Copyright (c) 2014 pketh. All rights reserved.
//

// MARK: - Saves API results to Model Objects

import Cocoa
import CoreData

class TrelloUser {

	init(userToken: String) {
		let token = userToken
		let trelloHelper = TrelloHelper()
		clearData()
		saveBoards()
	}

	func clearData() {
		// wipes board and lists model tables
	}

	func saveBoards() {
		println("hello")
	}

	func saveBoardColor() {
	}

	func saveList() {
	}

}

// MARK: - Model Objects

class Board: NSManagedObject {
	@NSManaged var boardColor: String
	@NSManaged var boardCustomBackground: AnyObject?
	@NSManaged var boardID: String
	@NSManaged var boardName: String
	@NSManaged var lists: NSSet
}

class List: NSManagedObject {
	@NSManaged var listID: String
	@NSManaged var listName: String
	@NSManaged var board: Board
}

class CardQueue: NSManagedObject {
	@NSManaged var boardID: String
	@NSManaged var cardName: String
	@NSManaged var listID: String
}
