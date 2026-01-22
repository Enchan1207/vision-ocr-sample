//
//  OcrViewModel.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import AppKit
import CoreGraphics

@MainActor
final class OcrViewModel: ObservableObject {
    @Published var state: OcrState
    
    let engine: OcrEngine
        
    init(engine: OcrEngine) {
        self.engine = engine
        self.state = .empty
    }
    
    func didDropFile(url: URL){
        guard let image = NSImage(contentsOf: url) else {
            self.state = .error(.invalidUrl(url))
            return
        }
        
        DispatchQueue.main.async {
            // Convert NSImage to CGImage when storing state
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                self.state = .imageLoaded(cgImage)
            } else {
                self.state = .error(.failedToConvertImage)
            }
        }
    }
    
    func didClickRecognize(){
        Task {
            guard case .imageLoaded(let cgImage) = state else {return}
            
            self.state = .textRecognizing(cgImage)
            
            do {
                let result = try await self.engine.recognizeText(from: cgImage)
                
                await MainActor.run {
                    guard case .textRecognizing(let currentImage) = self.state else {return}
                    self.state = .textRecognized(currentImage, result)
                }
            } catch {
                await MainActor.run {
                    self.state = .error(.recognitionFailed(error))
                }
            }
        }
    }
}
