//
//  CacheService.swift
//  TheBigBangTheory
//
//  Created by Eduardo Santiz on 4/11/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class CacheService {
    private let cacheAsset: NSCache = NSCache<NSString, UIImage>()
    
    static let shared = CacheService()
    private init(){}
    
    func saveToCache(with identifier: String, for image: UIImage) {
        cacheAsset.setObject(image, forKey: identifier as NSString)
    }
    
    func loadFromCache(with identifier: String) -> UIImage? {
        return cacheAsset.object(forKey: identifier as NSString)
    }
}
