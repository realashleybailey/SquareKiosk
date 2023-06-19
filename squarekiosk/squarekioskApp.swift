//
//  squarekioskApp.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import SwiftUI
//import Network

@main
struct squarekioskApp: App {

	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	@StateObject var menu = MenuStore()
	@StateObject var selected = SelectedStore()

	@State var networkUp: Bool = true

//	let monitor = NWPathMonitor()

	var body: some Scene {
		WindowGroup {
			ZStack {
				ContentView()
					.environmentObject(menu)
					.environmentObject(selected)
					.onAppear(perform: self.loadData)
					.onAppear(perform: self.watchNetwork)
					.ignoresSafeArea(.keyboard)
					.onShake {
						let player = playSound()
						createAlert(title: "Theft Detected", message: "This device can not be tamperd with, and is being actively monitored") { _ in
							player?.stop()
						}
					}
				
				VStack {
					if (!networkUp) {
						networkBanner
					}
				}
					.transition(.opacity)
					.animation(.easeInOut)


				VStack {
					Spacer()
					HStack {

						Rectangle()
							.foregroundColor(Color(uiColor: UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.00)))
							.frame(width: 100, height: 100)
							.onTapGesture(count: 3, perform: self.secretMenu)

						Spacer()
					}
				}

			}.ignoresSafeArea(.keyboard)
		}
	}

	var networkBanner: some View {
		VStack {
			HStack {
				Spacer()
				Text("NO NETWORK CONNECTION").bold()
				Spacer()
			}
				.font(.headline)
				.foregroundColor(.white)
				.frame(width: UIScreen.main.bounds.width, height: 65)
				.background(Color.red)

			Spacer()
		}
	}

	func secretMenu() {
		let rootView = AdminLogin()
			.environmentObject(menu)
			.environmentObject(selected)

		let vc = UIHostingController(rootView: rootView)
		vc.modalPresentationStyle = .pageSheet
		vc.isModalInPresentation = true

		presentInKeyWindow(controller: vc)
	}

	func watchNetwork() {
//		monitor.pathUpdateHandler = { path in
//			if path.status == .satisfied {
//				self.networkUp = true
//				DispatchQueue.main.async {
//					self.selected.toast = toastObject(title: "Network Connected", type: .complete(.green), displayMode: .hud)
//				}
//			} else {
//				self.networkUp = false
//			}
//		}
//
//		let queue = DispatchQueue(label: "Monitor")
//		monitor.start(queue: queue)
	}

	func loadData() {
		menu.loadCategorys()
		menu.loadItems()
	}
}
