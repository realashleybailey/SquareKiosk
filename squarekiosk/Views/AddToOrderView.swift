//
//  AddToOrderView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 15/01/2022.
//

import SwiftUI

struct AddToOrderView: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	var title: String
	var item: ItemObject

	@State var stepperCount: Int = 1

	var body: some View {
		VStack {
			VStack(spacing: 0) {
				HStack {
					Text("\(self.title): \(self.item.itemVariationData?.name ?? "")")
						.font(Font.custom("square", size: 25))
						.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
					Spacer()
				}.padding(.horizontal, 40).padding(.vertical, 30)

				Divider()
			}

			VStack {

				Text("Select Quantity")
					.font(Font.custom("square", size: 20))
					.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))

				CustomStepper(quantity: self.$stepperCount)

				Spacer()

				HStack {
					Spacer()

					Text("Total: ")
						.font(Font.custom("square", size: 20))
						.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
						.bold()

					Text(totalPrice(pence: (self.stepperCount * (self.item.itemVariationData?.priceMoney?.amount ?? 0))))
						.font(Font.custom("square", size: 20))
						.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))

				}

			}.padding(40)

			Spacer()

			VStack(spacing: 0) {
				Divider()

				HStack {
					Spacer()

					Button(action: self.dismissView) {
						Text("Close")
							.font(Font.custom("square", size: 15))
							.foregroundColor(.white)
							.padding()
							.frame(height: 40)
							.background(Color(uiColor: UIColor(red: 0.42, green: 0.46, blue: 0.49, alpha: 1.00)))
							.cornerRadius(6)
					}

					Button(action: self.addToCart) {
						Text("Add to Order")
							.font(Font.custom("square", size: 15))
							.foregroundColor(.white)
							.padding()
							.frame(height: 40)
							.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
							.cornerRadius(6)
					}
				}.padding(.horizontal, 40).padding(.vertical, 30)
			}
		}
	}

	func addToCart() {
		let id = self.item.id
		let name = "\(self.title): \(self.item.itemVariationData?.name ?? "")"
		let count = self.stepperCount
		let price = self.item.itemVariationData?.priceMoney?.amount ?? 0
		let category = getCategoryByItemID(itemID: self.item.itemVariationData?.itemID, item: self.menu.item, category: self.menu.category)

		if let i = self.menu.cart.firstIndex(where: { $0.id == id }) {
			self.menu.cart[i].count += 1
		} else {
			let object = CartObject(id: id, name: name, price: price, count: count, category: category)
			self.menu.cart.append(object)
		}

		getTopViewController()?.dismiss(animated: true)
		self.goToHome()
		self.selected.toast = toastObject(title: "\(self.title) Added", type: .complete(Color.green))
	}

	func dismissView() {
		getTopViewController()?.dismiss(animated: true)
		self.selected.toast = toastObject(title: "\(self.title) Not Added", type: .error(Color.yellow))
	}

	func goToHome() {
		self.selected.currentSelected = selectedObject(id: nil, type: .none)
	}
}

//struct AddToOrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToOrderView()
//    }
//}
