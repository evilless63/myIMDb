//
//  ImdbCollectionsModel.swift
//  myIMDb
//
//  Created by Vitaliy on 13.08.2021.
//

import UIKit

struct ImdbCollectionModel {
    let id: String
    let title: String
    let imageUrl: String
    var image: UIImage {
        let url = URL(string: imageUrl)!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            return UIImage(data: imageData)!
        }
        return UIImage()
    }
    let year: Int?
    let imdbRating: Double?
}
