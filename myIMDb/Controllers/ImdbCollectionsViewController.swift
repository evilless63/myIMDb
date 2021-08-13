//
//  ViewController.swift
//  myIMDb
//
//  Created by Vitaliy on 13.08.2021.
//

import UIKit

class ImdbCollectionsViewController: UIViewController {

    var imdbCollercionImporter = ImdbCollectionsImporter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imdbCollercionImporter.delegate = self
        imdbCollercionImporter.loadCollections()
    }
    
}

extension ImdbCollectionsViewController: ImdbCollectionsImporterDelegate {
    
    func didUpdateImdbCollection(_ ImdbCollectionsImporter: ImdbCollectionsImporter, ImdbCollectionItems: [ImdbCollectionType: [ImdbCollectionModel]]) {
        DispatchQueue.main.async {
            for (type, items) in ImdbCollectionItems {
                print("type: \(type)")
                for item in items {
                    print("id: \(item.id) ,title: \(item.title)")
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error fetching: \(error)")
    }
    
}

