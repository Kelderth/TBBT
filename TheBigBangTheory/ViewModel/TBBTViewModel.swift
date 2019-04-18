//
//  TBBTViewModel.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/8/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class TBBTViewModel {
    let ns = NetworkService()
    let baseURL = #"https://api.tvmaze.com/shows/66?embed=seasons&embed=episodes"#
    private var show: TBBTModel?
    private var episodes: [Episode] = [Episode]()
    
    func downloadJSON(completion: @escaping () -> Void) {
        ns.downloadData(from: baseURL) { (data) in
            guard let jsonData = data else {
                completion()
                return
            }

            let jsonParsed = try? JSONDecoder().decode(TBBTModel.self, from: jsonData)
            
            if let episondes = jsonParsed {
                self.show = episondes
                completion()
            } else {
                completion()
            }
        }
    }
    
    func downloadImage(from url: URL ,completion: @escaping (UIImage?) -> Void) {
        let imageCacheIdentifier = #"\#(url)"#
        if let image = CacheService.shared.loadFromCache(with: imageCacheIdentifier) {
            completion(image)
        } else {
            ns.downloadImage(from: url) { (image) in
                if let image = image {
                    CacheService.shared.saveToCache(with: imageCacheIdentifier, for: image)
                    completion(image)
                }
            }
        }
    }
    
    func setEpisodes() {
        episodes = show?.episodes?.episodes ?? []
    }
    
    func getNumberOfSeasons() -> Int {
        let seasons: Set = Set(episodes.map({$0.season}))
        return seasons.count
    }
    
    func getNumberOfChapters(for season: Int) -> Int {
        let season = season + 1
        
        let chapters = episodes.filter({$0.season == season})
        return chapters.count
    }
    
    func getChapterTitle (season: Int, chapter: Int) -> String {
        let season = season + 1
        let chapter = chapter + 1
        let episode = episodes.filter({$0.season == season && $0.chapter == chapter})
        
        return episode[0].name
    }
    
    func getChapterImage (season: Int, chapter: Int) -> URL?{
        let season = season + 1
        let chapter = chapter + 1
        let episode = episodes.filter({$0.season == season && $0.chapter == chapter})
        
        return episode[0].image?.original
    }
    
    func getEpisodeInfo(season: Int, chapter: Int) -> Episode {
        let season = season + 1
        let chapter = chapter + 1
        let episode = episodes.filter({$0.season == season && $0.chapter == chapter})
        
        return episode[0]
    }
}
