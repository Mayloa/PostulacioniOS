//
//  datosPeliculas.swift
//  PostulacioniOS
//
//  Created by Mayte López Aguilar on 15/01/21.
//

import Foundation

// MARK: - DatosPeliculas
struct DatosPeliculas: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages
        case totalResults
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct Result: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int?
    let original_language: OriginalLanguage?
    let original_title, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdrop_path
        case genre_ids
        case id
        case original_language
        case original_title
        case overview, popularity
        case poster_path
        case release_date
        case title, video
        case vote_average
        case vote_count
    }
}

enum OriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case no = "no"
    case zh = "zh"
}
