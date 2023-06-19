//
//  menuStore.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import Foundation
import Alamofire

class MenuStore: ObservableObject {

	@Published var item: Item?
	@Published var category: Category?
	
	@Published var cart: [CartObject] = []

	func loadCategorys() {
		
		let sandbox = UserDefaultsRead(key: UCKey.sandboxMode) as? Bool ?? false
		let sandboxTXT = sandbox ? "sandbox" : "production"
		
		let apiURL = UserDefaultsRead(key: UCKey.apiURL) as? String ?? ""
		
		let headers: HTTPHeaders = [
			"Accept": "application/json",
			"Enviroment": sandboxTXT
		]
		
		let request = AF.request(apiURL + "/api/products/category/list", method: .get, headers: headers)

		request.responseDecodable(of: Category.self) { response in

			guard let responseValue = response.value else {
				NSLog("Could not get Category List")
				return
			}

			self.category = responseValue

		}
	}

	func loadItems() {

		let sandbox = UserDefaultsRead(key: UCKey.sandboxMode) as? Bool ?? false
		let sandboxTXT = sandbox ? "sandbox" : "production"
		
		let apiURL = UserDefaultsRead(key: UCKey.apiURL) as? String ?? ""
		
		let headers: HTTPHeaders = [
			"Accept": "application/json",
			"Enviroment": sandboxTXT
		]
		
		let request = AF.request(apiURL + "/api/products/item/list", method: .get, headers: headers)

		request.responseDecodable(of: Item.self) { response in
			
			guard let responseValue = response.value else {
				NSLog("Could not get Item List")
				return
			}
			
			let conditions: [(ItemObject) -> Bool] = [
				{ $0.itemData?.productType == ProductType.regular },
				{ $0.itemData?.categoryID?.isEmpty == false }
			]
			
			let itemObjects = Item(objects: responseValue.objects.filter { item in
				conditions.reduce(true) { $0 && $1(item) }
			})
			
			self.item = itemObjects
			
		}
	}
}
