//
//  OcrResult.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import CoreGraphics
import Foundation

struct OcrResult: Hashable {
  let text: String
  let boundingBox: CGRect
}
