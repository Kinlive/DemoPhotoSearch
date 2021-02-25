//
//  CacheManager.swift
//  DemoPhotoSearch
//
//  Created by Kinlive on 2021/2/26.
//

import UIKit

class CacheManager: NSObject {
    public static let shared: CacheManager = CacheManager()

    public private(set) var imageCache = Cache<String, UIImage>()

    func clearCache() {
        imageCache.removeAllValue()
    }
}
