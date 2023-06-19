//
//  KioskConfig.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import Foundation

struct KioskConfigElement: Codable {
	let id: String = UUID().uuidString
	let apiURL: String
	let kioskName, locationID, deviceID, enviroment: String
	let adminPIN: String
	
	enum CodingKeys: String, CodingKey {
		case apiURL = "api_url"
		case kioskName = "kiosk_name"
		case locationID = "location_id"
		case deviceID = "device_id"
		case enviroment
		case adminPIN = "pin_code"
	}
}
