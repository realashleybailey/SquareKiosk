//
//  Item.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 10/12/2021.
//

import Foundation

struct Item: Codable {
    let objects: [ItemObject]
}

struct ItemData: Codable {
	let name: String
	let itemDataDescription, categoryID: String?
	let variations: [ItemObject]
	let productType: ProductType?
	let ordinal: Int?
	let visibility: String?
	let skipModifierScreen: Bool?
	let ecomVisibility: String?
	let itemOptions: [ItemOption]?
	
	enum CodingKeys: String, CodingKey {
		case name
		case itemDataDescription = "description"
		case categoryID = "category_id"
		case variations
		case productType = "product_type"
		case ordinal, visibility
		case skipModifierScreen = "skip_modifier_screen"
		case ecomVisibility = "ecom_visibility"
		case itemOptions = "item_options"
	}
}

struct ItemObject: Codable, Identifiable {
	let id: String
	let type: String?
	let createdAt: String?
	let version: Int?
	let isDeleted, presentAtAllLocations: Bool?
	let itemData: ItemData?
	let itemVariationData: ItemVariationData?
	
	enum CodingKeys: String, CodingKey {
		case type, id
		case createdAt = "created_at"
		case version
		case isDeleted = "is_deleted"
		case presentAtAllLocations = "present_at_all_locations"
		case itemData = "item_data"
		case itemVariationData = "item_variation_data"
	}
}

struct ItemVariationData: Codable {
	let itemID, name: String?
	let ordinal: Int?
	let pricingType: String?
	let priceMoney: PriceMoney?
	let sellable, stockable: Bool?
	let serviceDuration: Int?
	let priceDescription: String?
	let availableForBooking: Bool?
	let transitionTime: Int?
	let teamMemberIDS: [String]?
	
	enum CodingKeys: String, CodingKey {
		case itemID = "item_id"
		case name, ordinal
		case pricingType = "pricing_type"
		case priceMoney = "price_money"
		case sellable, stockable
		case serviceDuration = "service_duration"
		case priceDescription = "price_description"
		case availableForBooking = "available_for_booking"
		case transitionTime = "transition_time"
		case teamMemberIDS = "team_member_ids"
	}
}

struct PriceMoney: Codable {
    let amount: Int
    let currency: String
}

enum ProductType: String, Codable {
	case appointmentsService = "APPOINTMENTS_SERVICE"
	case regular = "REGULAR"
}

struct ItemOption: Codable {
	let itemOptionID: String
	
	enum CodingKeys: String, CodingKey {
		case itemOptionID = "item_option_id"
	}
}
