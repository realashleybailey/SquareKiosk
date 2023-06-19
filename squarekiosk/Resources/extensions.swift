//
//  extensions.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import Foundation
import SwiftUI

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}

extension UIApplication {
	var keyWindow: UIWindow? {
		return UIApplication.shared.connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.first(where: { $0 is UIWindowScene })
			.flatMap({ $0 as? UIWindowScene })?.windows
			.first(where: \.isKeyWindow)
	}
}

extension UIApplication {
	
	var keyWindowPresentedController: UIViewController? {
		var viewController = self.keyWindow?.rootViewController
		
		if let presentedController = viewController as? UITabBarController {
			viewController = presentedController.selectedViewController
		}
		
		while let presentedController = viewController?.presentedViewController {
			if let presentedController = presentedController as? UITabBarController {
				viewController = presentedController.selectedViewController
			} else {
				viewController = presentedController
			}
		}
		
		return viewController
	}
	
}

extension UIViewController {
	
	func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			UIApplication.shared.keyWindow?.rootViewController?
				.present(self, animated: animated, completion: completion)
		}
	}
	
	func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
		DispatchQueue.main.async {
			UIApplication.shared.keyWindowPresentedController?
				.present(self, animated: animated, completion: completion)
		}
	}
	
}

func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
	if let nav = base as? UINavigationController {
		return getTopViewController(base: nav.visibleViewController)
		
	} else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
		return getTopViewController(base: selected)
		
	} else if let presented = base?.presentedViewController {
		return getTopViewController(base: presented)
	}
	return base
}

func keyWindowPresentedController(base: UIApplication? = UIApplication.shared) -> UIViewController {
	var viewController = base?.keyWindow?.rootViewController
	
	if let presentedController = viewController as? UITabBarController {
		viewController = presentedController.selectedViewController
	}
	
	while let presentedController = viewController?.presentedViewController {
		if let presentedController = presentedController as? UITabBarController {
			viewController = presentedController.selectedViewController
		} else {
			viewController = presentedController
		}
	}
	
	return viewController!
}

func presentInKeyWindow(controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
	DispatchQueue.main.async {
		UIApplication.shared.keyWindow?.rootViewController?
			.present(controller, animated: animated, completion: completion)
	}
}

func presentInKeyWindowPresentedController(controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
	DispatchQueue.main.async {
		keyWindowPresentedController().present(controller, animated: animated, completion: completion)
	}
}


	// The notification we'll send when a shake gesture happens.
extension UIDevice {
	static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

	//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
	open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
		}
	}
}

	// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
	let action: () -> Void
	
	func body(content: Content) -> some View {
		content
			.onAppear()
			.onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
				action()
			}
	}
}

	// A View extension to make the modifier easier to use.
extension View {
	func onShake(perform action: @escaping () -> Void) -> some View {
		self.modifier(DeviceShakeViewModifier(action: action))
	}
}

