//
//  ImdbImporter.swift
//  myIMDb
//
//  Created by Vitaliy on 13.08.2021.
//

import Foundation

protocol ImdbCollectionsImporterDelegate {
    func didUpdateImdbCollection(_ ImdbCollectionsImporter: ImdbCollectionsImporter, ImdbCollectionItems: [ImdbCollectionType: [ImdbCollectionModel]])
    func didFailWithError(error: Error)
}

struct ImdbCollectionsImporter {

    private let apiKey: String = "k_utjycy38"
    private let lang: String = "en"
    var delegate: ImdbCollectionsImporterDelegate?
    
    func loadCollections() {
        performUrlRequest(with: "https://imdb-api.com/\(lang)/API/MostPopularMovies/\(apiKey)", type: ImdbCollectionType.MostPopularMovies)
        performUrlRequest(with: "https://imdb-api.com/\(lang)/API/MostPopularTVs/\(apiKey)", type: ImdbCollectionType.MostPopularTVs)
        performUrlRequest(with: "https://imdb-api.com/\(lang)/API/InTheaters/\(apiKey)", type: ImdbCollectionType.InTheaters)
        performUrlRequest(with: "https://imdb-api.com/\(lang)/API/ComingSoon/\(apiKey)", type: ImdbCollectionType.ComingSoon)
    }
    
    private func performUrlRequest(with urlString: String, type collectionType: ImdbCollectionType ) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
//                  print("we had some error when performing request: \(String(describing: error))")
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let saveData = data {
//                  let dataString = String(data: getData, encoding: .utf8)
//                  print(dataString!)
                    if let ImdbCollectionItems = self.parseJson(with: saveData, collectionType: collectionType) {
                        delegate?.didUpdateImdbCollection(self, ImdbCollectionItems: ImdbCollectionItems)
                    }
                }
            }
            
            task.resume()
        }
    }

    func parseJson(with saveData: Data, collectionType: ImdbCollectionType) -> [ImdbCollectionType: [ImdbCollectionModel]]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImdbCollectionData.self, from: saveData)
            
//          print(decodedData)
            var ArrCollectionOfItems = [ImdbCollectionModel]()
            for item in decodedData.items {
                let id = item.id
                let title = item.title
                let imageUrl = item.image
                let year = Int(item.year) ?? nil
                let imdbRating = Double(item.imDbRating) ?? nil
                let imdbCollectionItem = ImdbCollectionModel(id: id, title: title, imageUrl: imageUrl, year: year, imdbRating: imdbRating)
                ArrCollectionOfItems.append(imdbCollectionItem)
            }
            let resultItemsByTypes: [ImdbCollectionType: [ImdbCollectionModel]] = [collectionType:ArrCollectionOfItems]
            return resultItemsByTypes
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
