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

        let results: [OcrResult] = observations.compactMap { observation in
          guard let candidate = observation.topCandidates(1).first else { return nil }
            return .init(text: candidate.string, boundingBox: observation.boundingBox)
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
