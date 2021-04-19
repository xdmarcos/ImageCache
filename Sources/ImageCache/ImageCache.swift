//
//  ImageCache.swift
//  ImageCache
//
//  Created by xdmgzdev on 15/04/2021.
//

import Foundation
import UIKit

public class ImageCache {
  public static let `public` = ImageCache()
  public var placeholderImage = UIImage(systemName: "photo")!
  private let cachedImages = NSCache<NSURL, UIImage>()
  private var loadingResponses = [NSURL: [(ImageItem, UIImage?) -> Swift.Void]]()

  public final func image(url: NSURL) -> UIImage? {
    return cachedImages.object(forKey: url)
  }

  /// - Tag: cache
  // Returns the cached image if available, otherwise asynchronously loads and caches it.
  public final func load(
    url: NSURL,
    item: ImageItem,
    queue: DispatchQueue = .main,
    completion: @escaping (ImageItem, UIImage?) -> Swift.Void
  ) {
    // Check for a cached image.
    if let cachedImage = image(url: url) {
      queue.async {
        completion(item, cachedImage)
      }
      return
    }
    // In case there are more than one requestor for the image, we append their completion block.
    if loadingResponses[url] != nil {
      loadingResponses[url]?.append(completion)
      return
    } else {
      loadingResponses[url] = [completion]
    }
    // Go fetch the image.
    ImageURLLoadable.urlSession().dataTask(with: url as URL) { data, _, error in
      // Check for the error, then data and try to create the image.
      guard let responseData = data, let image = UIImage(data: responseData),
            let blocks = self.loadingResponses[url], error == nil
      else {
        queue.async {
          completion(item, nil)
        }
        return
      }
      // Cache the image.
      self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
      // Iterate over each requestor for the image and pass it back.
      for block in blocks {
        queue.async {
          block(item, image)
        }
        return
      }
    }.resume()
  }
}
