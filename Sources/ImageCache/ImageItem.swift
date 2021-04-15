//
//  ImageItem.swift
//  ImageCache
//
//  Created by xdmgzdev on 15/04/2021.
//

import UIKit

class ImageItem: Hashable {
  let identifier = UUID()
  var image: UIImage!
  let url: URL!

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  init(image: UIImage, url: URL) {
    self.image = image
    self.url = url
  }
}
