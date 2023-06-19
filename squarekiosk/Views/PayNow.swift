//
//  PayNow.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 15/01/2022.
//

import SwiftUI
import Firebase

struct PayNow: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	@State private var isRotated = false
	@State private var isSpring = false
	
	@State private var successfulText = true

	@State private var progress: ORDER_PROGRESS?
	@State private var snapshot: ListenerRegistration?

	var order: OrderResponseData

	var spinnerAnimation: Animation {
		Animation.linear(duration: 4)
			.repeatForever(autoreverses: false)
	}
	var springAnimation: Animation {
		Animation.interpolatingSpring(stiffness: 400, damping: 5, initialVelocity: 20)
			.repeatForever(autoreverses: false)
	}

	init(order: OrderResponseData) {
		self.order = order
	}

	var body: some View {
		VStack {
			switch self.progress {
			case .PENDING:
				pleaseWait
			case .IN_PROGRESS:
				pleasePay
			case .CANCEL_REQUESTED:
				canceled
			case.CANCELED:
				canceled
			case.COMPLETED:
				successful
			default:
				pleaseWait
			}
		}.onAppear(perform: self.openLiveOrder)
			.transition(.opacity)
			.animation(.easeInOut, value: self.progress)
			.statusBar(hidden: true)
	}

	func openLiveOrder() {
		
		let id = UserDefaultsRead(key: UCKey.deviceID) as? String
		
		guard let id = id else {
			createAlert(title: "Device ID", message: "Device ID not set in Admin Settings") { _ in
				getTopViewController()?.dismiss(animated: true, completion: {
					self.menu.cart = []
					self.selected.toast = toastObject(title: "Error Occurred", type: .error(Color.red), displayMode: .hud)
				})
			}
			
			return
		}
		
		createTerminal(orderID: self.order.orderId, deviceID: id) { responseBool in
			if responseBool {
				
				let db = Firestore.firestore()
				
				self.snapshot = db.collection("kiosk").document(self.order.orderId).addSnapshotListener { querySnapshot, error in
					
					guard let document = querySnapshot?.data() else {
						createAlert(title: "Error Occurred", message: "An error has occurred please see a member of staff.\n\nOrder ID: \(self.order.orderId)") { _ in
							print("Error")
							getTopViewController()?.dismiss(animated: true, completion: {
								self.menu.cart = []
								self.selected.toast = toastObject(title: "Error Occurred", type: .error(Color.red), displayMode: .hud)
							})
						}
						return
					}
					
					let progressString = document["terminal"] as? String
					
					if rawToEnum(progressString) != .PENDING {
						self.progress =  rawToEnum(progressString)
					}
				}
				
			} else {
				
				print("Response")
				print(responseBool)
				
				createAlert(title: "Error Occurred", message: "An error has occurred please see a member of staff.\n\nOrder ID: \(self.order.orderId)") { _ in
					print("Error")
					getTopViewController()?.dismiss(animated: true, completion: {
						self.menu.cart = []
						self.selected.toast = toastObject(title: "Error Occurred", type: .error(Color.red), displayMode: .hud)
					})
				}
			}
		}
	}

	func rawToEnum(_ progress: String?) -> ORDER_PROGRESS {
		switch progress {
		case "PENDING":
			return ORDER_PROGRESS.PENDING
		case "IN_PROGRESS":
			return ORDER_PROGRESS.IN_PROGRESS
		case "CANCEL_REQUESTED":
			return ORDER_PROGRESS.CANCEL_REQUESTED
		case "CANCELED":
			return ORDER_PROGRESS.CANCELED
		case "COMPLETED":
			return ORDER_PROGRESS.COMPLETED
		default:
			return ORDER_PROGRESS.PENDING
		}
	}
	enum ORDER_PROGRESS {
		case PENDING
		case IN_PROGRESS
		case CANCEL_REQUESTED
		case CANCELED
		case COMPLETED
	}

	func transactionCancel() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
			getTopViewController()?.dismiss(animated: true, completion: {
				self.selected.currentSelected = selectedObject(id: nil, type: .none)
				self.menu.cart = []
				self.selected.toast = toastObject(title: "Transaction Canceled", type: .error(Color.red), displayMode: .hud)
			})
		}
	}

	func transactionSuccess() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.successfulText = false
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
			getTopViewController()?.dismiss(animated: true, completion: {
				self.selected.currentSelected = selectedObject(id: nil, type: .none)
				self.menu.cart = []
				self.selected.toast = toastObject(title: "Transaction Successful", type: .complete(.green), displayMode: .hud)
			})
		}
	}

	var pleaseWait: some View {
		VStack {
			Spacer()
			HStack {
				Text("Please wait a \nmoment")
					.font(Font.custom("square", size: 60))
					.foregroundColor(.white)

				Spacer()

				Image("spinner")
					.resizable()
					.frame(width: UIScreen.main.bounds.height / 2.5, height: UIScreen.main.bounds.height / 2.5)
					.rotationEffect(Angle.degrees(isRotated ? 300 : 0))
					.animation(spinnerAnimation)
					.onAppear(perform: { self.isRotated.toggle() })

			}.padding(50)
			Spacer()
		}.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
	}

	var pleasePay: some View {
		VStack {
			Spacer()
			HStack {
				Text("Please make a \npayment")
					.font(Font.custom("square", size: 60))
					.foregroundColor(.white)

				Spacer()

				Image("arrow")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: UIScreen.main.bounds.height / 3)
					.animation(springAnimation)
					.offset(x: isSpring ? -20 : 0)
					.onAppear(perform: { self.isSpring.toggle() })

			}.padding(50)
			Spacer()
		}.background(Color(uiColor: UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)))
	}

	var canceled: some View {
		VStack {
			Spacer()
			HStack {
				Text("The transaction was\ncancelled")
					.font(Font.custom("square", size: 60))
					.foregroundColor(.white)

				Spacer()

				Image("warning")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: UIScreen.main.bounds.height / 3)

			}.padding(50)
			Spacer()
		}.background(Color(uiColor: UIColor(red: 0.89, green: 0.20, blue: 0.18, alpha: 1.00)))
			.onAppear(perform: self.transactionCancel)
	}

	var successful: some View {
		VStack {
			Spacer()
			HStack {
				
				if self.successfulText {
				Text("The transaction was\nsuccessful")
						.font(Font.custom("square", size: 60))
					.foregroundColor(.white)
				} else {
					VStack(alignment: .leading) {
						Text("Your order number:")
							.font(Font.custom("square", size: 50))
							.foregroundColor(.white)
						
						Text("\(self.order.orderNumber)")
							.font(Font.custom("square", size: 70))
							.foregroundColor(.white)
							.bold()
					}
				}

				Spacer()

				AnimatedCheckmark(color: Color(uiColor: UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.15)), size: Int(UIScreen.main.bounds.width / 4))

			}.padding(50)
			Spacer()
		}.background(Color(uiColor: UIColor(red: 0.22, green: 0.76, blue: 0.45, alpha: 1.00)))
			.onAppear(perform: self.transactionSuccess)
	}

}

//struct PayNow_Previews: PreviewProvider {
//	static var previews: some View {
//		PayNow()
//	}
//}
