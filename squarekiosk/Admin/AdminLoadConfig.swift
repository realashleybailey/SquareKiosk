//
//  AdminLoadConfig.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import SwiftUI

struct AdminLoadConfig: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore
	
	@State var configs: [KioskConfigElement] = []

	var body: some View {
		VStack(alignment: .leading, spacing: 15) {

			Form {
				Section {
					Text("Load this devices data from config file retireved from Firebase Remote Config, tap on the config your would like to use.")
				}
				
				Section {
					ForEach(self.configs, id: \.id) { config in
						NavigationLink(destination: VStack {
							Form {
								Section {
									(Text("Kiosk Name: ").bold() + Text("\(config.kioskName)"))
									(Text("Device ID: ").bold() + Text("\(config.deviceID)"))
									(Text("Location ID: ").bold() + Text("\(config.locationID)"))
									(Text("API URL: ").bold() + Text("\(config.apiURL)"))
									(Text("Enviroment: ").bold() + Text("\(config.enviroment)"))
									(Text("Admin PIN: ").bold() + Text("\(config.adminPIN)"))
								}
								
								Section {
								
									Button(action: { setConfigs(config) }) {
										Text("Set Configuration")
									}
								}
							}
						}) {
							Text(config.kioskName)
						}
					}
				}
			}
			
		}.onAppear(perform: self.loadConfigs)
	}
	
	func loadConfigs() {
		
		do {
			
			let decoder = JSONDecoder()
			let configJson = RemoteConfigManager.value(forKey: "kiosk_config")
			
			print(configJson)
			
			let data = try decoder.decode([KioskConfigElement].self, from: configJson.data(using: .utf8)!)
			self.configs = data
			
		} catch {
			
			print(error.localizedDescription)
			print(String(describing: error))
			
		}
	}
	
	func setConfigs(_ data: KioskConfigElement) {
		
		UserDefaultsSet(data: data.kioskName, key: UCKey.kioskName)
		UserDefaultsSet(data: data.deviceID, key: UCKey.deviceID)
		UserDefaultsSet(data: data.locationID, key: UCKey.locationID)
		UserDefaultsSet(data: data.apiURL, key: UCKey.apiURL)
		UserDefaultsSet(data: data.adminPIN, key: UCKey.adminPin)
		
		if data.enviroment == "production" {
			UserDefaultsSet(data: false, key: UCKey.sandboxMode)
		}
		
		if data.enviroment == "sandbox" {
			UserDefaultsSet(data: true, key: UCKey.sandboxMode)
		}
		
		createAlert(title: "Config Set", message: "The configuration has been successfully set") { _ in
			
			menu.item = nil
			menu.category = nil
			menu.cart = []
			
			menu.loadItems()
			menu.loadCategorys()
			
			getTopViewController()?.dismiss(animated: true)
		}
	}
}

struct AdminLoadConfig_Previews: PreviewProvider {
	static var previews: some View {
		AdminLoadConfig()
	}
}
