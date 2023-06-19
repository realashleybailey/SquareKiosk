//
//  AppDelegates.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import Foundation
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		
		FirebaseApp.configure()
		RemoteConfigManager.configure(expirationDuration: 0)
		
		UIApplication.shared.isStatusBarHidden = true

		return true
	}
}
