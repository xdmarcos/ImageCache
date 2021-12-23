// 
// File.swift
// 
//
// Created by Marcos González on 2021.
// 
//

import UIKit

extension UIImage {
	func hasSameData(_ image: UIImage?) -> Bool {
		self.pngData() == image?.pngData()
	}
}

extension UIImageView {
	public func loadImage(for item: ImageCacheItem, animated: Bool = false, completion: @escaping (Result<ImageCacheItem, Error>) -> Void) {
		ImageCache.public.load(url: item.url as NSURL, item: item) { fetchedItem, image in
			guard let newImage = image else {
				completion(.failure(ImageCacheError.failedToDownload))
				return
			}

			if newImage.hasSameData(fetchedItem.image) {
				completion(.success(item))
			} else {
				item.image = newImage
				if animated {
					UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
							self.image = newImage
						}, completion: nil)
				} else {
					self.image = newImage
				}

				completion(.success(item))
			}
		}
	}

	public func cancelImageLoad(_ url: URL) {
		ImageCache.public.cancelLoad(url as NSURL)
	}
}
