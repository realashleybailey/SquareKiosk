//
//  ItemListView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import SwiftUI

struct ItemListView: View {
	
	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore
	
	var body: some View {
		ForEach(self.itemObjects(id: self.selected.currentSelected.id ?? ""), id: \.id) { item in
			Button(action: { self.buttonAction(id: item.id, pageTitle: item.itemData?.name ?? "Ashleys Party") }) {
				itemCard(categoryName: getCategoryByID(id: item.itemData?.categoryID, category: menu.category), text: item.itemData?.name ?? "")
			}
		}
		.onAppear(perform: {
			self.selected.lastSelected = selectedObject(id: nil, type: .none)
		})
	}
	
	func buttonAction(id: String, pageTitle: String) {
		NSLog("ITEM ID: \(id)")
		self.selected.lastSelected = selectedObject(id: self.selected.currentSelected.id, type: .item, pageTitle: self.selected.currentSelected.pageTitle)
		self.selected.currentSelected = selectedObject(id: id, type: .variation, pageTitle: pageTitle)
	}
	
	func itemObjects(id: String) -> [ItemObject] {
		guard let itemObjects = self.menu.item?.objects else {
			NSLog("Failed")
			return []
		}
		
		let filteredObjects = itemObjects.filter {
			$0.itemData!.categoryID == id
		}
		
		return filteredObjects
	}
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListView()
//    }
//}
