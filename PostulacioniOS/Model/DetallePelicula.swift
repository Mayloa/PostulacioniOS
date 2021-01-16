//
//  DetallePelicula.swift
//  PostulacioniOS
//
//  Created by Mayte López Aguilar on 15/01/21.
//

import Foundation

// MARK: - DetallePelicula
struct DetallePelicula: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdb_id, original_language, original_title, overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [ProductionCompany]?
    let production_countries: [ProductionCountry]?
    let release_date: String?
    let revenue, runtime: Int?
    let spoken_languages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdrop_path
        case belongs_to_collection
        case budget, genres, homepage, id
        case imdb_id
        case original_language
        case original_title
        case overview, popularity
        case poster_path
        case production_companies
        case production_countries
        case release_date
        case revenue, runtime
        case spoken_languages
        case status, tagline, title, video
        case vote_average
        case vote_count
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, poster_path, backdrop_path: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case poster_path
        case backdrop_path
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logo_path: String?
    let name, origin_country: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logo_path
        case name
        case origin_country
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let english_name, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case english_name
        case iso639_1
        case name
    }
}
