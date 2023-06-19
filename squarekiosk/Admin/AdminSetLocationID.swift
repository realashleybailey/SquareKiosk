//
//  AdminSetLocationID.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import SwiftUI

struct AdminSetLocationID: View {
	
	@State var locationID: String = ""
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			
			Text("Set the Location ID that is in your square account")
			
			TextField("Kiosk Name", text: self.$locationID)
				.textFieldStyle(.roundedBorder)
				.onAppear(perform: self.getLocationID)
			
			Button(action: self.setLocationID) {
				Text("Set Location ID")
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
	
	func getLocationID() {
		let locationID = UserDefaultsRead(key: UCKey.locationID) as? String ?? ""
		self.locationID = locationID
	}
	
	func setLocationID() {
		UserDefaultsSet(data: self.locationID, key: UCKey.locationID)
	}
}

struct AdminSetLocationID_Previews: PreviewProvider {
    static var previews: some View {
        AdminSetLocationID()
    }
}
