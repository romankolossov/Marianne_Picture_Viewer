//
//  PhotoCodable.swift
//  MariannePictureViewer
//
//  Created by Roman Kolosov on 14.02.2021.
//

import Foundation

// Data to save

class PhotoElementData {
    //var sourceID: String?
    var author: String?
    let downloadURL: String?
    
    init(photoElement: PhotoElement) {
        //self.sourceID = photoElement.id
        
        self.author = photoElement.author
        self.downloadURL = photoElement.downloadURL
    }
}

// MARK: - PhotoElement

struct PhotoElement: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias PhotoQuery = [PhotoElement]
