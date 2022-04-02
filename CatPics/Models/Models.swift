//
//  Models.swift
//  CatPics
//
//  Created by Alba Venzal on 02/04/2022.
//

import Foundation

struct Breed: Codable, Identifiable {
    let id: String
    let name: String
}

struct GetImageRequest {
    let breedId: String
    let numberOfImages: Int // Must be between 1 and 100
}

struct CatImage: Codable, Identifiable {
    let id: String
    let url: URL
}
