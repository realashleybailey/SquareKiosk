//
//  Cart.swift
//  squarekiosk
//
//  Created by Ashley Bailey on 15/01/2022.
//

import Foundation

struct Cart {
	var objects: [CartObject]
}

struct CartObject: Codable {
	var id: String
	var name: String
	var price: Int
	var count: Int
	var category: String
}
