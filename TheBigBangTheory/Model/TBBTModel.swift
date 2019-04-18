//
//  TBBTModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/7/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import Foundation

struct TBBTModel: Codable {
    let showName: String
    let language: String
    var genres: [String]?
    let status: String
    let premiered: String
    let officialSite: URL
    let network: Network?
    var image: Image?
    let summary: String
    var episodes: Episodes?
    
    enum CodingKeys: String, CodingKey {
        case showName = "name"
        case language
        case genres
        case status
        case premiered
        case officialSite
        case network
        case image
        case summary
        case episodes = "_embedded"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.showName = try container.decodeIfPresent(String.self, forKey: .showName) ?? "Title not available."
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? "Language not available."
        self.genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? "Status not available."
        self.premiered = try container.decodeIfPresent(String.self, forKey: .premiered) ?? "Premiered not available."
        self.officialSite = try (container.decodeIfPresent(URL.self, forKey: .officialSite) ?? nil)!
        self.network = try container.decodeIfPresent(Network.self, forKey: .network) ?? nil
        self.image = try container.decodeIfPresent(Image.self, forKey: .image) ?? nil
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? "Summary not available."
        self.episodes = try container.decodeIfPresent(Episodes.self, forKey: .episodes) ?? nil
    }
}

struct Network: Codable {
    let networkName: String
    let country: Country?
    
    enum CodingKeys: String, CodingKey {
        case networkName = "name"
        case country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.networkName = try container.decodeIfPresent(String.self, forKey: .networkName) ?? "Network name not available"
        self.country = try container.decodeIfPresent(Country.self, forKey: .country) ?? nil
    }
}

struct Country: Codable {
    let countryName: String
    let countryCode: String
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case countryName = "name"
        case countryCode = "code"
        case timezone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName) ?? "NA"
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode) ?? "NA"
        self.timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? "NA"
    }
}

struct Image: Codable {
    let medium: URL?
    let original: URL?
    
    enum CodingKeys: String, CodingKey {
        case medium
        case original
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.medium = try container.decodeIfPresent(URL.self, forKey: .medium) ?? nil
        self.original = try container.decodeIfPresent(URL.self, forKey: .original) ?? nil
    }
}

struct Episodes: Codable {
    let episodes: [Episode]?
    
    enum CodingKeys: String, CodingKey {
        case episodes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.episodes = try container.decodeIfPresent([Episode].self, forKey: .episodes) ?? []
    }
}

struct Episode: Codable {
    let name: String
    let season: Int
    let chapter: Int
    let airDate: String
    let airTime: String
    let image: Image?
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case season
        case chapter = "number"
        case airDate = "airdate"
        case airTime = "airtime"
        case image
        case summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "N/A"
        self.season = try container.decodeIfPresent(Int.self, forKey: .season) ?? 0
        self.chapter = try container.decodeIfPresent(Int.self, forKey: .chapter) ?? 0
        self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate) ?? "N/A"
        self.airTime = try container.decodeIfPresent(String.self, forKey: .airTime) ?? "N/A"
        self.image = try container.decodeIfPresent(Image.self, forKey: .image) ?? nil
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? "N/A"
    }
}
