//
//  OcrState.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import AppKit

enum OcrState {
  case empty
  case imageLoaded(NSImage)
  case textRecognizing(NSImage)
  case textRecognized(NSImage, [OcrResult])
  case error(OcrError)
}
