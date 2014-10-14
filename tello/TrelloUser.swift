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

	private func getBoards() {
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
					let jsonBoards: Array<JSON> = json["boards"].arrayValue
					self.getUser(json)
					for board in jsonBoards {
						let boardID: String = board["id"].string!
						let boardName = board["name"].string!
						self.saveBoard(boardID, boardName: boardName)
						self.getBoardColor(boardID)
						self.getLists(boardID)
					}
				}
			}
	}
	
	private func getUser(json: JSON) {
		let username = json["username"].string!
		let url = json["url"].string!
		let avatarHash: String = json["avatarHash"].string!
		let avatarPath = "https://trello-avatars.s3.amazonaws.com/\(avatarHash)/30.png"		
		Alamofire.request(.GET, avatarPath)
			.response {(request, response, avatarData, error) in
				if (error != nil) {
					self.handleConnectionError(error)
				} else {
					if let avatar = NSImage(data: avatarData! as NSData) {
						self.saveUser(username, url: url, avatar: avatar)						
					}
				}
		}
	}
	
	private func getBoardColor(boardID: String) {
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
					// println(json)
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

	private func getLists(boardID: String) {
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
	
	private func saveUser(username: String, url: String, avatar: NSImage) {
		println(avatar) //
		println(username) //
		println(url) //
		let userEntity = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext!) as User
		// save nsimge to coredata?
		
		
	}

	private func saveBoard(boardID: String, boardName: String) {
		let boardEntity = NSEntityDescription.insertNewObjectForEntityForName("Board", inManagedObjectContext: managedObjectContext!) as Board
		boardEntity.boardName = boardName
		boardEntity.boardID = boardID
		// how to deal w relationships ->
		// lists: NSSet
		// user: tello.User
	}
	
	private func saveBoardColor(boardID: String, boardColor: String) {
		// called from getBoardColor ..
		// saves the raw color to the fetched board id
	}
	
	private func saveBoardBackground(boardID: String, boardBackground: String) {
		// called from getBoardColor ..
		// saves the photo bk to the fetched board id
	}

	private func saveList() {
		// supposed to save each list to model
	}
	
	// MARK: Persistent Store Handlers
		
	func fetchContext() {
		// add param for predicate / entity name. specify a func for a specific fetch type
		// testing request:
		// let request = NSFetchRequest(entityName: "Board")
		// var error: NSError? = nil
		// request.predicate = NSPredicate(format: "boardID like %@", boardID)
		// let results: Array = managedObjectContext!.executeFetchRequest(request, error: &error)!
		// println(results)
		// for result in results {
		// 	println(result.boardName)
		// 	println(result.boardID)
		// 	// assignment => result.x = valueX
		// }
	}

	private func clearSavedModels() {
		// -> wipes board and lists model tables
		// -> clearData() clear after the initial ui refresh and before/accompanying only the first trellouser save event
		// - "Store everything in Core Data, except for sensitive information"
		// does avatarhash change when user pic changes? do i care? should this be part of the wipe as well? or should i do diffing on this to reduce redundant request?
	}

	func saveContext() {
		var error : NSError? = nil
		if !self.managedObjectContext!.save(&error) {
			NSLog("Unresolved error \(error), \(error!.userInfo)")
			abort()
		} else {
			println("👭 Save completed")
		}
	}
	
	deinit {
		// clear(), then/and save() now?
		println("🙋 TrelloUser de-inited")
	}

	// MARK: Error Handling

	private func handleConnectionError(error: NSError?) {
		println(error)
		// other types of errors? see trello api / nsurlconnection for possible error types. if many, that i want to handle differently/explicitly to make useful error msgs -> handleconnectionerrors enums func by type
	}

}
