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
	let requestTrelloMember = dispatch_queue_create("RequestTrelloMember", DISPATCH_QUEUE_SERIAL)

	init(userToken: String) {
		token = userToken
		self.getBoards()
	}

	//-> (Array<String>, Array<String>, String)
	private func getBoards() {
		let trelloMember = "https://api.trello.com/1/members/me"
		let boardParams = [
			"boards": "open",
			"key": trelloKey,
			"token": token
		]

		// ?vars for boardIDs, boardNames, avatarHash
		Alamofire.request(.GET, trelloMember, parameters: boardParams)
			.response {(request, response, data, error) in
				let json = JSONValue(data as NSData!)
				println(json)

				println("🐸🐸🐸🐸")
				let boardsJSON = json["boards"].array!
				println(boardsJSON)
				println(boardsJSON.count)

//				println(json["boards"][0]["id"])


				// 🔮parse out boardIds
				// parse out boardName
				// --> make this a DICT to pass to self.getBoardColors
				// parse out , avatarHash = "fb4e49d1cc52a8c4da3e6cebb600f64c"
				println("🐸 Async Frog Test")
				self.getAvatar(json)
			}
	}

	private func getAvatar(json: JSONValue) {
		let avatarHash = json["avatarHash"]
		println("avatar hash is \(avatarHash)")

		// let trelloAvatar = "https://trello-avatars.s3.amazonaws.com/\(avatarHash)/30.png"
		// save the avatar img to the keychain alongside the user token and name
		// save user as a top lvl coredata obcj w/ token in keychain 
		// - "Store everything in Core Data, except for sensitive information"
	}

	private func getBoardColors() {
		//        let trelloBoardColorURL = "https://api.trello.com/1/boards/\(boardID)/prefs?key=\(key)&token=\(user)"
		// has all logic/processing to store color / custom bk imag into model
	}

// MARK: saves all core data objs for Board

	private func saveBoardEntities() { // needs dict w boardnames/ids init
		// starts with a for loop that creates new Board instances for each board loop
//		boardColor: String
//		boardCustomBackground
//		boardID: String
//		boardName: String
//		
//		relationships ->
//		lists: NSSet
//		user: tello.User

//		println("🏪 \(boards)")
		getLists()
	}

	private func getLists() {
	}

	private func saveListEntities() {
	}

	private func clearData() {
		// wipes board and lists model tables
		// clearData() clear before a purposeful save and ui refresh only
	}

}
