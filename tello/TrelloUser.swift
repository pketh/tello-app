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
		self.GETBoards()
	}

	private func GETBoards() {
		let trelloMember = "https://api.trello.com/1/members/me"
		let boardParams = [
			"boards": "open",
			"key": trelloKey,
			"token": token
		]
		Alamofire.request(.GET, trelloMember, parameters: boardParams)
			.responseJSON {(request, response, jsonObject, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					let json = JSON(object: jsonObject!)

					// wrap in if let? for async time out issues?
					println(json) // prints full json

					let jsonBoards: Array<JSON> = json["boards"].arrayValue
					// println(jsonBoards.count) // returns 6
					
					for board in jsonBoards {
						println("🎆")
						// println(board)
						let boardID: String = board["id"].stringValue
						let boardName: String = board["name"].stringValue

						// needs to be wrapped in an if let? the json's already fetched, shouldn't need a new thread for assigment
						self.saveBoard(boardID, boardName: boardName)
						// + save id and name to core data
						self.GETBoardColor(boardID)
						self.GETAvatar(json)
						self.GETLists(boardID)
					}
				}
			}
	}
	
	private func GETBoardColor(boardID: String) {
		let trelloBoard = "https://api.trello.com/1/boards/\(boardID)/prefs"
		let colorParams: [String: AnyObject] = [
			"key": trelloKey,
			"token": token
		]
		Alamofire.request(.GET, trelloBoard, parameters: colorParams)
			.responseJSON {(request, response, jsonObject, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					let json = JSON(object: jsonObject!)
					// dupe of above: wrap in _if let_? for async time out issues?

					println(json) // prints full json
					// -> logic and processing to store board color, bk or custom bk imag into coredata
					// 1. determine if board color, photo/custom bk
					// 2.0 convert board color to NSColor (yay)
					// 2. save board color to model (either as final or placeholder): self.saveBoardColor(boardID, boardColor)
					// 3. if photo/custom bk:
						// 4. download the small photo
						// 5. roughly crop it down(?), for the view controller to fit it in a circle later
						// 6. save the bk to model : self.saveBoardBackground(boardID, boardBackground)
						
				}
			}
	}

	private func GETAvatar(json: JSON) {
		let avatarHash = json["avatarHash"].string!
		let avatar = "https://trello-avatars.s3.amazonaws.com/\(avatarHash)/30.png" // re '30': i need something at retina thumb size?
		Alamofire.request(.GET, avatar)
			.responseJSON {(request, response, data, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					println("avatar fetch 🙋")
					println(request)
					// -> what to do now?
					// save the avatar img to the keychain alongside the user token and name
					// save user as a top lvl coredata obcj w/ token in keychain
					// - "Store everything in Core Data, except for sensitive information"
					// does hash change when user pic changes? do i care? should this be part of the wipe as well? or should i do diffing on this?
				}
		}

	}
	
	private func GETLists(boardID: String) {
		let trelloLists = "https://api.trello.com/1/boards/\(boardID)/lists"
		let listParams: [String: AnyObject] = [
			"key": trelloKey,
			"token": token,
			"cards": "none",
			"card_fields": "name",
			"fields": "name"
		]
		Alamofire.request(.GET, trelloLists, parameters: listParams)
			.responseJSON {(request, response, jsonObject, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					let json = JSON(object: jsonObject!)
					// dupe of above: wrap in _if let_? for async time out issues?
					println(json) // prints full json
					
					// -> what to do now?
				}
			}
	}


	// MARK: Core Data Helpers

	private func saveBoard(boardID: String, boardName: String) { // needs dict w boardnames/ids init
		// boardID: String
		// boardName: String
		//
		// how to deal w relationships ->
		// lists: NSSet
		// user: tello.User
	}
	
	private func saveBoardColor(boardID: String, boardColor: String) {
		// called from GETBoardColor ..
		// saves the raw color to the fetched board id
	}
	
	private func saveBoardBackground(boardID: String, boardBackground: String) {
		// called from GETBoardColor ..
		// saves the photo bk to the fetched board id
	}

	private func saveList() {
		// supposed to save each list to model
	}

	private func clearSavedModels() {
		// -> wipes board and lists model tables
		// -> clearData() clear after the initial ui refresh and before/accompanying the first trellouser save event (only the first)
	}


	// MARK: Error Handling

	private func handleConnectionError(error: NSError?) {
		println(error)
		// other types of errors? see trello api / nsurlconnection for possible error types. if many, that i want to handle differently/explicitly to make useful error msgs -> handleconnectionerrors enums func by type
	}

}
