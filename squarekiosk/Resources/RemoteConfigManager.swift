//
//  RemoteConfigManager.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 13/12/2021.
//

import Firebase

struct RemoteConfigManager {

	private static var remoteConfig: RemoteConfig {
		let remoteConfig = RemoteConfig.remoteConfig()
		let settings = RemoteConfigSettings()
		settings.minimumFetchInterval = 0
		remoteConfig.configSettings = settings
		remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
		return remoteConfig
	}

	static func configure(expirationDuration: TimeInterval = 3600.0) {
		remoteConfig.fetch(withExpirationDuration: expirationDuration) { status, error in
			if let error = error {
				print(error.localizedDescription)
			}

			print("Successfully Recieved Remote Config")
			RemoteConfig.remoteConfig().activate(completion: nil)
		}
	}

	static func value(forKey key: String) -> String {
		return remoteConfig.configValue(forKey: key).stringValue!
	}
}
