//
//  ImageCacheItem.swift
//  ImageCache
//
//  Created by xdmgzdev on 15/04/2021.
//

import UIKit

public class ImageCacheItem: Hashable {
	private let identifier = UUID()

	public var image: UIImage?
	public let url: URL
	public var isCached: Bool = false

	public func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}

	public static func == (lhs: ImageCacheItem, rhs: ImageCacheItem) -> Bool {
		return lhs.identifier == rhs.identifier
	}

	public init(image: UIImage?, url: URL) {
		self.image = image
		self.url = url
	}
}
