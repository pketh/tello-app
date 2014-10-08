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
import AppKit // needed for nsimage?


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
					
					let jsonBoards: Array<JSON> = json["boards"].arrayValue
					// println(jsonBoards.count) // returns 6
					
					for board in jsonBoards {
						let boardID: String = board["id"].string!
						let boardName: String = board["name"].string!
						let avatarHash: String = json["avatarHash"].string!
						self.saveBoard(boardID, boardName: boardName)
						self.GetBoardColor(boardID)
						self.GetAvatar(avatarHash)
						self.GetLists(boardID)
					}
				}
			}
	}
	
	private func GetBoardColor(boardID: String) {
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
					// println(json) -> prints full json. contains height, width and full size url for board bk
					
					// each one returns in multiple sizes, get the url for the 140 x 100 version
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

	private func GetAvatar(avatarHash: String) {
		let avatar = "https://trello-avatars.s3.amazonaws.com/\(avatarHash)/30.png"
		Alamofire.request(.GET, avatar)
			.response {(request, response, avatarData, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					println("🐍")
					let backgroundImage = NSImage(data: avatarData! as NSData)
					// 🔮 avatarData needs to be converted to nsimage format (build an nsurl extension that feeds in w data from url?)
					// -> save the avatar 'data' img to the keychain alongside the user token and name
					// save user as a top lvl coredata obcj w/ token in keychain
					// - "Store everything in Core Data, except for sensitive information"
					// does hash change when user pic changes? do i care? should this be part of the wipe as well? or should i do diffing on this?
				}
		}

	}
	
	private func GetLists(boardID: String) {
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
