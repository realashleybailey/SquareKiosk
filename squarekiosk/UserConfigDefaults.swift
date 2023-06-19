//
//  UserConfigDefaults.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import Foundation

struct UCKey {
	static let deviceID = "device_id"
	static let adminPin = "admin_pin"
	static let sandboxMode = "sandbox_mode"
	static let kioskName = "kiosk_name"
	static let locationID = "location_id"
	static let apiURL = "api_url"
}

func UserDefaultsSet(data: Any?, key: String) {
	let defaults = UserDefaults.standard
	defaults.set(data, forKey: key)
}

func UserDefaultsRead(key: String) -> Any? {
	let defaults = UserDefaults.standard
	let data = defaults.value(forKey: key)
	return data
}
