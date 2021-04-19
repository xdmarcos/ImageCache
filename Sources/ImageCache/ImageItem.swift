//
//  ImageItem.swift
//  ImageCache
//
//  Created by xdmgzdev on 15/04/2021.
//

import UIKit

public class ImageItem: Hashable {
  let identifier = UUID()
  var image: UIImage
  let url: URL

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  init(image: UIImage, url: URL) {
    self.image = image
    self.url = url
  }
}
