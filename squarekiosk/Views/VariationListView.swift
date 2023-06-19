//
//  VariationListView.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import SwiftUI

struct VariationListView: View {

	@EnvironmentObject var menu: MenuStore
	@EnvironmentObject var selected: SelectedStore

	var body: some View {
		ForEach(self.variationObjects(id: self.selected.currentSelected.id ?? ""), id: \.id) { item in
			Button(action: { self.buttonAction(item: item) }) {
				itemCard(categoryName: categoryName, text: item.itemVariationData?.name ?? "")
			}
		}
	}

	func buttonAction(item: ItemObject) {
		let rootView = AddToOrderView(title: self.selected.currentSelected.pageTitle, item: item)
			.environmentObject(menu)
			.environmentObject(selected)

		let vc = UIHostingController(rootView: rootView)
		vc.modalPresentationStyle = .pageSheet
		vc.isModalInPresentation = true
		
		presentInKeyWindow(controller: vc)
	}

	func variationObjects(id: String) -> [ItemObject] {
		guard let itemObjects = self.menu.item?.objects else {
			NSLog("Failed")
			return []
		}

		let itemObject = itemObjects.first {
			$0.id == id
		}

		guard let itemObject = itemObject else {
			return []
		}

		guard let itemData = itemObject.itemData else {
			return []
		}

		return itemData.variations
	}

	var categoryName: String {
		guard let itemObjects = self.menu.item?.objects else {
			NSLog("Failed")
			return ""
		}

		let itemObject = itemObjects.first {
			$0.id == self.selected.currentSelected.id ?? ""
		}

		return getCategoryByID(id: itemObject?.itemData?.categoryID, category: menu.category)
	}
}



//struct VariationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        VariationListView()
//    }
//}
