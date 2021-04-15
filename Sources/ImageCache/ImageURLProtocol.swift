//
//  ImageURLProtocol.swift
//  ImageCache
//
//  Created by xdmgzdev on 15/04/2021.
//

import Foundation

class ImageURLProtocol: URLProtocol {
  var cancelledOrComplete: Bool = false
  var block: DispatchWorkItem!

  private static let queue = OS_dispatch_queue_serial(label: "gz.xdm.dev.imageLoaderURLProtocol")

  override class func canInit(with _: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override class func requestIsCacheEquivalent(_: URLRequest, to _: URLRequest) -> Bool {
    return false
  }

  override final func startLoading() {
    guard let reqURL = request.url, let urlClient = client else {
      return
    }

    block = DispatchWorkItem(block: {
      if self.cancelledOrComplete == false {
        let fileURL = URL(fileURLWithPath: reqURL.path)
        if let data = try? Data(contentsOf: fileURL) {
          urlClient.urlProtocol(self, didLoad: data)
          urlClient.urlProtocolDidFinishLoading(self)
        }
      }
      self.cancelledOrComplete = true
    })

    ImageURLProtocol.queue.asyncAfter(
      deadline: DispatchTime(uptimeNanoseconds: 500 * NSEC_PER_MSEC),
      execute: block
    )
  }

  override final func stopLoading() {
    ImageURLProtocol.queue.async {
      if self.cancelledOrComplete == false, let cancelBlock = self.block {
        cancelBlock.cancel()
        self.cancelledOrComplete = true
      }
    }
  }

  static func urlSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [ImageURLProtocol.classForCoder()]
    return URLSession(configuration: config)
  }
}