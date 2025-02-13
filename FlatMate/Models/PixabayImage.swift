//
//  PixabayImage.swift
//  FlatMate
//
//  Created by Ivan on 2025-02-04.
//

struct PixabayResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage]
}

struct PixabayImage: Decodable, Identifiable {
    let id: Int
    let pageURL: String?
    let type: String?
    let tags: String?
    
    let previewURL: String?
    let previewWidth: Int?
    let previewHeight: Int?
    
    let webformatURL: String?
    let webformatWidth: Int?
    let webformatHeight: Int?
    
    let largeImageURL: String?
    let imageWidth: Int?
    let imageHeight: Int?
    let imageSize: Int?
    
    let views: Int?
    let downloads: Int?
    let likes: Int?
    let comments: Int?
    
    let user_id: Int?
    let user: String?
    let userImageURL: String?
}
