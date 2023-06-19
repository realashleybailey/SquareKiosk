//
//  Category.swift
//  AshleysParty
//
//  Created by Ashley Bailey on 09/12/2021.
//

import Foundation

struct Category: Codable {
    let objects: [CategoryObject]
}

struct CategoryObject: Codable, Identifiable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let categoryData: CategoryData
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case categoryData = "category_data"
    }
}

struct CategoryData: Codable {
    let name: String
}
