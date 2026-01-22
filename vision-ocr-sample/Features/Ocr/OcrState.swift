//
//  OcrState.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import CoreGraphics

enum OcrState {
    case empty
    case imageLoaded(CGImage)
    case textRecognizing(CGImage)
    case textRecognized(CGImage, [OcrResult])
    case error(OcrError)
}
