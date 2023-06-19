//
//  CustomStepper.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 13/12/2021.
//

import SwiftUI

struct CustomStepper: View {

	@Binding var quantity: Int

	var body: some View {
		HStack(spacing: 0) {
			Button(action: { remove() }) {
				CircleWithBorder(icon: "minus")
			}
			
			Spacer()
			
			Text(String(quantity))
				.font(.system(size: 20, weight: .medium))
				.foregroundColor(.black)
				.lineLimit(1)
			
			Spacer()

			Button(action: { add() }) {
				CircleWithBorder(icon: "plus")
			}
		}
	}

	func add() {
		if (self.quantity == 100) {
			return
		}

		self.quantity += 1
	}

	func remove() {
		if (self.quantity == 1) {
			return
		}

		self.quantity -= 1
	}
}

struct CircleWithBorder: View {

	var icon: String

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 32)
				.fill(Color(#colorLiteral(red: 0.9725490212440491, green: 0.9725490212440491, blue: 0.9725490212440491, alpha: 1)))

			RoundedRectangle(cornerRadius: 32)
				.strokeBorder(Color(#colorLiteral(red: 0.5920000076293945, green: 0.5920000076293945, blue: 0.5920000076293945, alpha: 0.10415755957365036)), lineWidth: 1)
		}
			.frame(width: 64, height: 64)
			.overlay(Image(systemName: icon).foregroundColor(.black))
	}
}

struct CustomStepper_Previews: PreviewProvider {
	static var previews: some View {
		CustomStepper(quantity: .constant(1))
	}
}
