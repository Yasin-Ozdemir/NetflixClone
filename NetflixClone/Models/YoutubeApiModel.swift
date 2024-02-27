//
//  YoutubeApiModel.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 25.02.2024.
//


import Foundation



struct YoutubeApiModel: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: Video
}


struct Video: Codable {
    let kind: String
    let videoId: String
}




