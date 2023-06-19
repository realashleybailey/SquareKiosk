//
//  OrderNowView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 15/01/2022.
//

import SwiftUI
import AlertToast

struct OrderNowView: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	@State var loadingPay: Bool = false

	var griditems: [GridItem] {
		return Array(repeating: .init(.fixed(210)), count: 3)
	}

	var body: some View {
		ZStack {
			VStack {
				VStack(spacing: 0) {
					HStack {
						Text("Your Order")
							.font(Font.custom("square", size: 25))
							.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
						Spacer()
					}.padding(.horizontal, 40).padding(.vertical, 30)

					Divider().offset(y: 8)
				}

				if self.menu.cart.count > 0 {
					ScrollView(.vertical, showsIndicators: false) {
						LazyVGrid(columns: griditems, spacing: 20) {

							ForEach(self.menu.cart, id: \.id) { item in
								orderCard(id: item.id, categoryName: item.category, text: item.name, price: item.price, count: item.count)
							}

						}.padding(30)

						if self.totalCalcPrice < 100 {
							Text("Your total must be more than £1.00")
								.font(.footnote)
								.foregroundColor(.gray)
								.padding(10)
						}

					}
				} else {
					HStack {
						Spacer()
						(Text("Add Items to ") + Text("Cart").bold())
							.font(Font.custom("square", size: 25))
							.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
						Spacer()
					}.padding(50)
					Spacer()
				}

				VStack(spacing: 0) {
					Divider().offset(y: -8)

					HStack {

						Text("\(totalPrice(pence: self.totalCalcPrice))")
							.font(Font.custom("square", size: 25))
							.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))

						Spacer()

						Button(action: self.dismissView) {
							Text("Close")
								.font(Font.custom("square", size: 20))
								.foregroundColor(.white)
								.padding()
								.frame(height: 40)
								.background(Color(uiColor: UIColor(red: 0.42, green: 0.46, blue: 0.49, alpha: 1.00)))
								.cornerRadius(6)
						}

						Button(action: self.payNow) {
							Text("Pay now")
								.font(Font.custom("square", size: 20))
								.foregroundColor(.white)
								.padding()
								.frame(height: 40)
								.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: ((self.totalCalcPrice < 100) ? 0.5 : 1.00))))
								.cornerRadius(6)
						}.disabled(self.totalCalcPrice < 100)

					}.padding(.horizontal, 40).padding(.vertical, 30)
				}

			}


			if self.loadingPay {
				Color.black.opacity(0.5)

				ZStack {
					Spacer()
					ActivityIndicator(isAnimating: .constant(true), style: .large)
					Spacer()
				}
			}

		}
	}

	struct ActivityIndicator: UIViewRepresentable {

		@Binding var isAnimating: Bool
		let style: UIActivityIndicatorView.Style

		func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
			return UIActivityIndicatorView(style: style)
		}

		func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
			isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
		}
	}

	func dismissView() {
		getTopViewController()?.dismiss(animated: true)
		self.selected.toast = toastObject(title: "Not Paid Yet", type: .error(Color.yellow))
	}

	func payNow() {

		let lineItems = self.menu.cart
		self.loadingPay = true

		createOrder(lineItems: lineItems) { response in

			guard let response = response else {
				self.loadingPay = false
				createAlert(title: "There was an error", message: "We could not proccess this transaction please see a member of staff", completion: nil)
				return
			}

			getTopViewController()?.dismiss(animated: true)

			let rootView = PayNow(order: response)
				.environmentObject(menu)
				.environmentObject(selected)

			let vc = UIHostingController(rootView: rootView)
			vc.modalPresentationStyle = .fullScreen
			vc.isModalInPresentation = true

			presentInKeyWindow(controller: vc)
		}
	}

	var totalCalcPrice: Int {

		var price: Int = 0

		self.menu.cart.forEach { item in
			price += (item.price * item.count)
		}

		return price
	}
}

struct OrderNowView_Previews: PreviewProvider {
	static var previews: some View {
		OrderNowView()
	}
}
