//
//  TrelloUser.swift
//  tello
//
//  Created by Pirijan on 2014-09-18.
//  Copyright (c) 2014 pketh. All rights reserved.
//

// MARK: - ?Saves API results to Model Objects

import Cocoa
import CoreData


class TrelloUser {

	var token: String
	let managedObjectContext = (NSApplication.sharedApplication().delegate as AppDelegate).managedObjectContext

	init(userToken: String) {
		token = userToken
		let boards = getBoards() // returns tuple w 3 arrays
		saveBoardEntities(boards)

		let lists = getLists(boards) // do after
		saveListEntity()
	}

	func getBoards() {

	}

	func saveBoardEntities() { // boards tuple passed in, or a named subset.
		// retuerns [array of lists] for use by save list entity
		let trelloBoardReults = TrelloBoardResults(token: token)
		println(trelloBoardReults)
	}

	// func saveBoardColor() { // boardCustomBackground . will be passed in a path. purely async thread.
	// }

	func getLists() {
	}

	func saveListEntity() {
	}

	func clearData() {
		// wipes board and lists model tables
		// clearData() clear before a purposeful save and ui refresh only
	}

}
















//struct TrelloBoardResults {
//	var token: String
//	init(token: String) {
//		self.token = token
//	}
//	//		func getBoards(token: String) -> Array<String> {
//	// return ["x", "X"]
//	//		}
//	//		 results -> return a struct containing 3 arrays
//	//		 trelloBoards.names => [array of names]
//	//		 trelloBoards.colors => [array of colors]
//	//		 trelloBoards.IDs => [array of ids]
//}
//
//struct TrelloListResults {
//
//}



