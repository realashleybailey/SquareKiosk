//
//  selectedStore.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import Foundation
import SwiftUI
import AlertToast

class SelectedStore: ObservableObject {
	@Published var lastSelected: selectedObject = selectedObject(id: nil, type: .none)
	@Published var currentSelected: selectedObject = selectedObject(id: nil, type: .none)
	
	@Published var toast: toastObject?
}

struct toastObject {
	var title: String
	var type: AlertToast.AlertType = .regular
	var displayMode: AlertToast.DisplayMode = .hud
}


struct selectedObject: Hashable {
	var id: String?
	var type: selectedType
	var pageTitle: String = "Ashleys Party"
}

enum selectedType: Int, Codable {
	case none
	case item
	case variation
}
