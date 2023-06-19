//
//  AdminSetDeviceID.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import SwiftUI

struct AdminSetDeviceID: View {
	
	@State var deviceID: String = ""
	
	var body: some View {
		VStack {
			HStack {

				VStack {
					
					Image("Handset")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: (UIScreen.main.bounds.height / 3))
					
					Spacer()
					
				}

				VStack(alignment: .leading, spacing: 15) {
					
					Text("Enter in the Serial Number\ndisplayed on the back of the handset.")
					
					TextField("Input Device ID", text: self.$deviceID)
						.textFieldStyle(.roundedBorder)
					
					Button(action: self.setID) {
						Text("Set Device ID")
							.font(Font.custom("square", size: 15))
							.foregroundColor(.white)
							.padding()
							.frame(height: 40)
							.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
							.cornerRadius(6)
					}
					
					Spacer()
					
				}.padding(.leading).padding(.leading)
			}
			.padding()
			.padding()

			Spacer()
		}.onAppear(perform: self.getID)
	}
	
	func setID() {
		UserDefaultsSet(data: self.deviceID, key: UCKey.deviceID)
		createAlert(title: "Set ID", message: "Device ID set to " + self.deviceID, completion: nil)
	}
	
	func getID() {
		let id = UserDefaultsRead(key: UCKey.deviceID) as? String
		self.deviceID = id ?? ""
	}
}

struct AdminSetDeviceID_Previews: PreviewProvider {
	static var previews: some View {
		AdminSetDeviceID()
	}
}
