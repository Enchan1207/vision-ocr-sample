//
//  OcrViewModel.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import AppKit

final class OcrViewModel: ObservableObject {
  @Published var state: OcrState

  let engine: OcrEngine

  init(engine: OcrEngine) {
    self.engine = engine
    self.state = .empty
  }

  func didDropFile(url: URL) {
    guard let image = NSImage(contentsOf: url) else {
      self.state = .error(.invalidUrl(url))
      return
    }

    DispatchQueue.main.async {
      self.state = .imageLoaded(image)
    }
  }

  func didClickRecognize() {
    guard case .imageLoaded(let image) = state else { return }

    // FIXME: これ発生しうるだろうか?
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      self.state = .error(.failedToConvertImage)
      return
    }

    self.state = .textRecognizing(image)

    Task {
      do {
        let result = try await self.engine.recognizeText(from: cgImage)

        await MainActor.run {
          self.state = .textRecognized(image, result)
        }
      } catch {
        await MainActor.run {
          self.state = .error(.recognitionFailed(error))
        }
      }
    }
  }
}
