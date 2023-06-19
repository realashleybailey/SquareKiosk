//
//  ContentView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import SwiftUI
import AlertToast

struct ContentView: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	@State private var isShowingBackButton: Bool = false

	var griditems: [GridItem] {
		return Array(repeating: .init(.fixed(220)), count: 2)
	}

	var body: some View {
		VStack(alignment: .leading) {
			Spacer()

			titleBar

			ScrollView(.horizontal, showsIndicators: false) {
				LazyHGrid(rows: griditems, spacing: 20) {

					switch selected.currentSelected.type {
					case .none:
						CategoryListView()
					case .item:
						ItemListView()
					case .variation:
						VariationListView()
					}

				}
					.padding(.horizontal, 40)
					.transition(.opacity)
					.animation(.easeInOut, value: self.selected.currentSelected.type)
			}

			bottomBar

			Spacer()
		}
			.background(Color(uiColor: UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.00)))
			.onChange(of: { self.selected.currentSelected.id == nil }()) { _ in
			withAnimation(.easeInOut(duration: 0.5)) {
				self.isShowingBackButton = self.selected.currentSelected.type != .none
			}
		}
			.statusBar(hidden: true)
			.toast(isPresenting: self.toastBinding, alert: self.toastAlert)
	}

	var toastBinding: Binding<Bool> {
		return Binding(
			get: {
				return self.selected.toast != nil
			},
			set: { _ in
				self.selected.toast = nil
			})
	}
	var toastAlert: () -> AlertToast {
		return {
			return AlertToast(displayMode: self.selected.toast?.displayMode ?? .hud, type: self.selected.toast?.type ?? .regular, title: self.selected.toast?.title ?? "")
		}
	}

	var titleBar: some View {
		VStack(alignment: .leading) {
			Text(self.selected.currentSelected.pageTitle)
				.font(Font.custom("square", size: 25))
				.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
		}.padding(.horizontal, 40)
	}

	var bottomBar: some View {
		HStack {

			if isShowingBackButton {
				Button(action: { self.selected.currentSelected = self.selected.lastSelected }) {
					Text("Back")
						.font(Font.custom("square", size: 17))
						.foregroundColor(.white)
						.padding()
						.frame(height: 40)
						.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
						.cornerRadius(6)
				}
			}

			Spacer()

			Button(action: self.orderNowAction) {
				Text("Order now (\(self.cartCount))")
					.font(Font.custom("square", size: 17))
					.foregroundColor(.white)
					.padding()
					.frame(height: 40)
					.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
					.cornerRadius(6)
			}

		}.padding(.horizontal, 40)
	}
	
	var cartCount: Int {
		return self.menu.cart.count
	}
	
	func orderNowAction() {
		let rootView = OrderNowView()
			.environmentObject(menu)
			.environmentObject(selected)
		
		let vc = UIHostingController(rootView: rootView)
		vc.modalPresentationStyle = .pageSheet
		vc.isModalInPresentation = true
		
		presentInKeyWindow(controller: vc)
	}
}

struct itemCard: View {

	var categoryName: String
	var text: String

	var body: some View {
		HStack {
			VStack {
				Image(self.categoryName)
					.resizable()
					.frame(width: 70, height: 70)

				Text(self.text)
					.font(Font.custom("square", size: 25))
					.foregroundColor(Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.6)))
			}
		}
			.frame(width: 400, height: 200)
			.background(Color.white.cornerRadius(3).shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
