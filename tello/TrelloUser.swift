//
//  TrelloUser.swift
//  tello
//
//  Created by Pirijan on 2014-09-18.
//  Copyright (c) 2014 pketh. All rights reserved.
//

// MARK: - Refreshes User Data from Trello

import Cocoa
import CoreData
import Alamofire


class TrelloUser {

	var token: String
	let managedObjectContext = (NSApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
	let trelloKey = "8240d71e24f95848cb9ca146bc84ede7"
//	var avatarHash: String

	init(userToken: String) {
		token = userToken
// 🔮 make getBoards async
		//		let boards =
		getBoards() // returns tuple w 3 arrays
//		saveBoardEntities(boards)
		println("🐸 Async Frog Test")

//		let lists = getLists(boards) // do after
		saveListEntity()
	}

	//-> (Array<String>, Array<String>, Array<String>)
	func getBoards() {
		let trelloMember = "https://api.trello.com/1/members/me"
		let boardParams = [
			"boards": "open",
			"key": trelloKey,
			"token": token
		]
		Alamofire.request(.GET, trelloMember, parameters: boardParams)
			.responseJSON {(request, response, json, error) in
				println(json)

				// avatarHash = "fb4e49d1cc52a8c4da3e6cebb600f64c"

			}

	}

	func getAvatar() {
		// let trelloAvatar = "https://trello-avatars.s3.amazonaws.com/\(avatarHash)/30.png"
		// save the avatar img to the keychain alongside the user token and name
		// save user as a top lvl coredata obcj w/ token in keychain 
		// - "Store everything in Core Data, except for sensitive information"
	}

	func saveBoardEntities() { // boards tuple passed in, or a named subset.
		// retuerns [array of lists] for use by save list entity

//		let trelloBoardReults = TrelloBoardResults(token: token)
//		let boards = getBoards()

//		println("🏪 \(boards)")
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
