//
//  AdminMain.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 17/01/2022.
//

import SwiftUI

struct AdminMain: View {
	
	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore
	
	@State var sandboxMode: Bool = false
	
	var body: some View {
		NavigationView {
			VStack {

				Form {
					Section {
						NavigationLink(destination: AdminSetPin()) {
							Text("Set Admin Pin")
						}
						NavigationLink(destination: AdminSetDeviceID()) {
							Text("Set Device ID")
						}
						
						Toggle("Sandbox Mode", isOn: self.$sandboxMode)
							.onAppear(perform: {
								self.sandboxMode = UserDefaultsRead(key: UCKey.sandboxMode) as? Bool ?? false
							})
							.onChange(of: self.sandboxMode) { newValue in
								UserDefaultsSet(data: newValue, key: UCKey.sandboxMode)
							}
						
						NavigationLink(destination: AdminSetKioskName()) {
							Text("Kiosk Name")
						}
						NavigationLink(destination: AdminSetLocationID()) {
							Text("Set Location ID")
						}
						
					}
					
					Section {
						NavigationLink(destination: AdminLoadConfig()) {
							Text("Load from Config")
						}
					}

					Section {
						Button(action: { getTopViewController()?.dismiss(animated: true) }) {
							Text("Exit Admin Panel").foregroundColor(.red)
						}
					}

				}

			}.navigationTitle("Menu").navigationBarTitleDisplayMode(.inline)
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct AdminMain_Previews: PreviewProvider {
	static var previews: some View {
		AdminMain()
	}
}
