//
//  OcrUsecase.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import AppKit
import Vision

final class OcrUsecase {
    func recognize(_ image: NSImage) async {
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            for observation in observations {
                if let candidate = observation.topCandidates(1).first {
                    print(candidate.string)
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ja-JP"]
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        try? handler.perform([request])
    }
}
