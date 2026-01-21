//
//  VisionOcrEngine.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import CoreGraphics
import Foundation
import Vision

final class VisionOcrEngine: OcrEngine {
  func recognizeText(from image: CGImage) async throws -> [OcrResult] {
    // FIXME: AIに適当に書かせただけ、後でロジックを整理する
    return try await withCheckedThrowingContinuation { continuation in
      let request = VNRecognizeTextRequest { request, error in
        if let error = error {
          continuation.resume(throwing: OcrError.recognitionFailed(error))
          return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
          continuation.resume(returning: [])
          return
        }

        let width = CGFloat(image.width)
        let height = CGFloat(image.height)

        let results: [OcrResult] = observations.compactMap { observation in
          guard let candidate = observation.topCandidates(1).first else { return nil }

          // Vision boundingBox is normalized (0..1) with origin at bottom-left.
          // Convert to image pixel coordinates with origin at top-left.
          let bbox = observation.boundingBox
          let rect = CGRect(
            x: bbox.minX * width,
            y: (1 - bbox.maxY) * height,
            width: bbox.width * width,
            height: bbox.height * height
          )

          return OcrResult(text: candidate.string, boundingBox: rect)
        }

        continuation.resume(returning: results)
      }

      request.recognitionLevel = .accurate
      request.recognitionLanguages = ["ja-JP"]
      request.usesLanguageCorrection = true

      let handler = VNImageRequestHandler(cgImage: image, options: [:])
      do {
        try handler.perform([request])
      } catch {
        continuation.resume(throwing: OcrError.recognitionFailed(error))
      }
    }
  }
}
