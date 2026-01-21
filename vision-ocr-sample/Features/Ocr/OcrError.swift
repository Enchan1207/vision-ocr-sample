//
//  OcrError.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/21.
//

import Foundation

enum OcrError: Error {
  case invalidUrl(URL)
  case failedToConvertImage
  case recognitionFailed(Error)
}
