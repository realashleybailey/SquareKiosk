//
//  AdminSetKioskName.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import SwiftUI

struct AdminSetKioskName: View {
	
	@State var kioskName: String = ""
	
    var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			
			Text("Set the name that you would like to use to identify this kiosk")
			
			TextField("Kiosk Name", text: self.$kioskName)
				.textFieldStyle(.roundedBorder)
				.onAppear(perform: self.getName)
			
			Button(action: self.setName) {
				Text("Set Kiosk Name")
					.font(Font.custom("square", size: 15))
					.foregroundColor(.white)
					.padding()
					.frame(height: 40)
					.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
					.cornerRadius(6)
			}
			
			Spacer()
			
		}.padding().padding()
    }
	
	func getName() {
		let name = UserDefaultsRead(key: UCKey.kioskName) as? String ?? ""
		self.kioskName = name
	}
	
	func setName() {
		UserDefaultsSet(data: self.kioskName, key: UCKey.kioskName)
	}
}

struct AdminSetKioskName_Previews: PreviewProvider {
    static var previews: some View {
		AdminSetKioskName()
    }
}
