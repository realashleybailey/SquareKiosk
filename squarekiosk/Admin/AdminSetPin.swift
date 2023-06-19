//
//  AdminSetPin.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 26/01/2022.
//

import SwiftUI

struct AdminSetPin: View {

	@State var pinCode: String = ""
	@State var buttonState: Bool = false

	var body: some View {

		VStack {

			PinEntryView(pinCode: self.$pinCode)
				.padding(.bottom)
				.onChange(of: self.pinCode) { newValue in
				if newValue.count == 4 {
					self.buttonState = true
				} else {
					self.buttonState = false
				}
			}

			HStack {
				Button(action: self.setPin) {
					Text("Set Pin")
						.font(Font.custom("square", size: 15))
						.foregroundColor(.white)
						.padding()
						.frame(height: 40)
						.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
						.cornerRadius(6)
				}
					.disabled(!self.buttonState)
					.opacity(self.buttonState ? 1 : 0.4)

				Button(action: self.clearPin) {
					Text("Clear")
						.font(Font.custom("square", size: 15))
						.foregroundColor(.white)
						.padding()
						.frame(height: 40)
						.background(Color(uiColor: UIColor(red: 0.89, green: 0.20, blue: 0.18, alpha: 1.00)))
						.cornerRadius(6)
				}
			}

			Spacer()
		}
	}

	func setPin() {
		
		let pin = self.pinCode
		self.pinCode = ""
		
		UserDefaultsSet(data: pin, key: UCKey.adminPin)
		createAlert(title: "Pin Set", message: "Admin PIN has been set to " + pin, completion: nil)
	}

	func clearPin() {
		self.pinCode = ""
	}
}

struct AdminSetPin_Previews: PreviewProvider {
	static var previews: some View {
		AdminSetPin()
	}
}
