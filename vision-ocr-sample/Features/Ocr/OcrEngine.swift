//
//  OcrEngine.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import CoreGraphics
import Foundation

protocol OcrEngine {
  func recognizeText(from image: CGImage) async throws -> [OcrResult]
}
