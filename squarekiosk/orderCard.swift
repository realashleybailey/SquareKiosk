//
//  orderCard.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 15/01/2022.
//

import SwiftUI

struct orderCard: View {

	@EnvironmentObject var menu: MenuStore

	var id: String
	var categoryName: String
	var text: String
	var price: Int
	var count: Int

	var body: some View {
		VStack(spacing: 0) {

			Spacer()

			VStack {
				Image(self.categoryName)
					.resizable()
					.frame(width: 50, height: 50)

				Text(self.text)
					.font(.system(size: 20))
					.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
					.multilineTextAlignment(.center)

				Text(totalPrice(pence: self.price))
					.font(.system(size: 20))
					.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
					.multilineTextAlignment(.center)
			}


			Spacer()

			Button(action: self.deleteItem) {
				HStack {

					Spacer()

					Text("Delete")
						.foregroundColor(.white)
						.bold()

					Spacer()
				}
					.frame(height: 35)
					.background(Color(uiColor: UIColor(red: 0.89, green: 0.20, blue: 0.18, alpha: 1.00)))
					.cornerRadius(3)
			}
		}
			.frame(width: 180, height: 200)
			.padding()
			.background(Color.white.cornerRadius(3).shadow(color: .black.opacity(0.2), radius: 3, x: 1.5, y: 1.5))
	}

	func deleteItem() {
		self.menu.cart.removeAll {
			$0.id == self.id
		}
	}
}

//struct orderCard_Previews: PreviewProvider {
//    static var previews: some View {
//        orderCard()
//    }
//}
