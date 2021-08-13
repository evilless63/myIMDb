//
//  ImdbCollectionsData.swift
//  myIMDb
//
//  Created by Vitaliy on 13.08.2021.
//

import Foundation

struct ImdbCollectionData: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: String
    let title: String
    let image: String
    let year: String
    let imDbRating: String
}
