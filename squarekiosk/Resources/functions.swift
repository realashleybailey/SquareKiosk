//
//  functions.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 14/01/2022.
//

import Foundation
import SwiftUI
import Alamofire

func createOrder(lineItems: [CartObject], completion: @escaping (OrderResponseData?) -> Void) {
	
	let locationID = UserDefaultsRead(key: UCKey.locationID) as! String
	let apiURL = UserDefaultsRead(key: UCKey.apiURL) as! String
	let name = UserDefaultsRead(key: UCKey.kioskName) as? String ?? "Kiosk 1"
	
	let sandbox = UserDefaultsRead(key: UCKey.sandboxMode) as? Bool ?? false
	let sandboxTXT = sandbox ? "sandbox" : "production"
	
	print(sandbox)
	print(sandboxTXT)
	
	let headers: HTTPHeaders = [
		"Accept": "application/json",
		"Enviroment": sandboxTXT
	]
	
	let parameters = OrderParams(idempotencyKey: UUID().uuidString, lineItems: lineItems, locationID: locationID, kioskName: name)
	
	let request = AF.request(apiURL + "/api/kiosk/createorder", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: headers)
	
	request.responseString { response in
		print(response.data)
	}
	
	request
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])

	request.responseDecodable(of: OrderResponse.self) { response in
		completion(response.value?.data)
	}
}

func createTerminal(orderID: String, deviceID: String, completion: @escaping (Bool) -> Void) {
	
	let apiURL = UserDefaultsRead(key: UCKey.apiURL) as! String

	let sandbox = UserDefaultsRead(key: UCKey.sandboxMode) as? Bool ?? false
	let sandboxTXT = sandbox ? "sandbox" : "production"
	
	let headers: HTTPHeaders = [
		"Accept": "application/json",
		"Enviroment": sandboxTXT
	]
	
	let parameters = TerminalParams(idempotencyKey: UUID().uuidString, orderID: orderID, deviceID: deviceID)
	
	let request = AF.request(apiURL + "/api/kiosk/createterminal", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: headers)
	
	request.responseString { response in
		print(response)
	}
	
	request
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
	
	request.response { response in
		if response.value != nil {
			completion(true)
		} else {
			completion(false)
		}
	}
}

struct OrderParams: Encodable {
	var idempotencyKey: String
	var lineItems: [CartObject]
	var locationID: String
	var kioskName: String
}

struct TerminalParams: Encodable {
	var idempotencyKey: String
	var orderID: String
	var deviceID: String
}

struct OrderResponse: Decodable {
	var data: OrderResponseData
}

struct OrderResponseData: Decodable {
	var orderId: String
	var orderNumber: String
}

func createAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: completion))
	presentInKeyWindowPresentedController(controller: alert)
}

func getCategoryByID(id: String?, category: Category?) -> String {
	guard let id = id else {
		NSLog("Optinal ID not found")
		return "defaultIcon"
	}

	guard let categoryObjects = category?.objects else {
		NSLog("Could not retrive Category Objects")
		return "defaultIcon"
	}

	let category = categoryObjects.filter {
		$0.id == id
	}

	guard let categoryName = category.first?.categoryData.name else {
		NSLog("Could not retrieve Category Name")
		return "defaultIcon"
	}

	return categoryName
}

func getCategoryByItemID(itemID: String?, item: Item?, category: Category?) -> String {
	guard let id = itemID else {
		NSLog("Optinal ID not found")
		return "defaultIcon"
	}

	guard let itemObjects = item?.objects else {
		NSLog("Could not retrive Item Objects")
		return "defaultIcon"
	}

	guard let categoryObjects = category?.objects else {
		NSLog("Could not retrive Category Objects")
		return "defaultIcon"
	}

	let item = itemObjects.first {
		$0.id == id
	}

	guard let categoryID = item?.itemData?.categoryID else {
		NSLog("Could not retrive CategoryID")
		return "defaultIcon"
	}

	let category = categoryObjects.filter {
		$0.id == categoryID
	}

	guard let categoryName = category.first?.categoryData.name else {
		NSLog("Could not retrieve Category Name")
		return "defaultIcon"
	}

	return categoryName
}

func totalPrice(pence: Int) -> String {

	let formatter = NumberFormatter()
	formatter.numberStyle = .currency

	let total = Double(pence) / 100

	return formatter.string(from: NSNumber(value: total)) ?? "£0.00"

}
