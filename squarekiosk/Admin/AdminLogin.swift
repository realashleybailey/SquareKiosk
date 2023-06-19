//
//  AdminLogin.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 17/01/2022.
//

import SwiftUI

struct AdminLogin: View {
	
	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	@State var loggedIn: Bool = false
	@State var pinCode: String = ""
	@State var pinCodeStored: String = ""

	var body: some View {
		ZStack {
			switch loggedIn {
			case false:
				loginScreen
			case true:
				AdminMain()
			}
		}
	}

	var loginScreen: some View {
		VStack {
			VStack {
				Spacer()
				
				PinEntryView(pinCode: self.$pinCode)
					.onChange(of: self.pinCode, perform: self.onChangeVal)
					.padding(.bottom, 10)
				
				Spacer()
				Spacer()
			}.padding(60)
			
			Spacer()
			
			HStack {
				
				Spacer()
				
				Button(action: { getTopViewController()?.dismiss(animated: true, completion: nil) }) {
					Text("Cancel")
						.foregroundColor(.red)
						.bold()
				}
				
			}.padding(30)
		}.onAppear(perform: self.getPin)
	}

	func onChangeVal(newValue: String) {
		if newValue.count == 4 {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
				if newValue == self.pinCodeStored {
					self.loggedIn.toggle()
				} else {
					self.pinCode = ""
				}
			})
		}
	}
	
	func getPin() {
		
		let pin = UserDefaultsRead(key: UCKey.adminPin) as? String
		
		guard let pin = pin else {
			self.loggedIn = true
			return
		}
		
		if pin.count == 0 {
			self.loggedIn = true
		}
		
		self.pinCodeStored = pin
	}
}

struct PinEntryView: View {

	@Binding var pinCode: String

	var body: some View {
		VStack(spacing: 40) {
			PinLine(pin: self.$pinCode)
			PinPad(pin: self.$pinCode)
		}
	}
}

struct PinLine: View {
	
	@Binding var pin: String
	
	private var pins: [String] {
		return pin.map { String($0) }
	}
	
	var body: some View {
		VStack {
			if pin.count == 0 {
				Text("Enter Passcode")
					.font(.title)
					.bold()
			} else {
				HStack(spacing: 32) {
					ForEach(0 ..< 4) { item in
						if item < pin.count {
							Text(pins[item])
								.font(.title)
								.bold()
							
						} else {
							Circle()
								.stroke(Color.secondary, lineWidth: 4)
								.frame(width: 16, height: 16)
						}
					}
					.frame(width: 24, height: 32)
				}
			}
		}
		.frame(height: 40)
	}
}


struct PinPad: View {

	@Binding var pin: String

	var body: some View {
		VStack {
			HStack {
				PinPadButton(number: "1", pin: self.$pin)
				PinPadButton(number: "2", pin: self.$pin)
				PinPadButton(number: "3", pin: self.$pin)
			}
			HStack {
				PinPadButton(number: "4", pin: self.$pin)
				PinPadButton(number: "5", pin: self.$pin)
				PinPadButton(number: "6", pin: self.$pin)
			}
			HStack {
				PinPadButton(number: "7", pin: self.$pin)
				PinPadButton(number: "8", pin: self.$pin)
				PinPadButton(number: "9", pin: self.$pin)
			}
			HStack {
				Spacer()
				PinPadButton(number: "0", pin: self.$pin)
				Spacer()
			}
		}
	}

}

struct PinPadButton: View {

	var number: String

	@Binding var pin: String

	var body: some View {
		Button(action: self.pinAjust) {
			VStack(alignment: .center) {
				Spacer()
				Text(number)
					.font(.system(size: 40))
					.foregroundColor(.black.opacity(0.7))
					.bold()
				Spacer()
			}
				.frame(width: 100, height: 80)
				.background(.white)
				.cornerRadius(5)
				.shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
		}
	}
	
	func pinAjust() {
		if self.pin.count <= 3 {
			self.pin = "\(pin)\(number)"
		}
	}
}

struct AdminLogin_Previews: PreviewProvider {
	static var previews: some View {
		AdminLogin()
	}
}
