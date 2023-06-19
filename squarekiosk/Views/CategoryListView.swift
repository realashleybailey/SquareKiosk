//
//  CategoryListView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import SwiftUI

struct CategoryListView: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	var body: some View {
		ForEach(self.categoryObjects, id: \.id) { item in
			Button(action: { self.buttonAction(id: item.id, pageTitle: item.categoryData.name) }) {
				itemCard(categoryName: item.categoryData.name, text: item.categoryData.name)
			}
		}
	}
	
	func buttonAction(id: String, pageTitle: String) {
		NSLog("CATEGORY ID: \(id)")
		self.selected.lastSelected = selectedObject(id: nil, type: .none)
		self.selected.currentSelected = selectedObject(id: id, type: .item, pageTitle: pageTitle)
	}

	var categoryObjects: [CategoryObject] {
		guard let categoryObjects = self.menu.category?.objects else {
			NSLog("Failed")
			return []
		}

		return categoryObjects
	}
}

struct CategoryListView_Previews: PreviewProvider {
	static var previews: some View {
		CategoryListView()
	}
}
