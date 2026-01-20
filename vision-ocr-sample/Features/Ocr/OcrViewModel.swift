//
//  OcrViewModel.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import AppKit

final class OcrViewModel: ObservableObject {
    @Published var image: NSImage?
    
    func didDropFile(url: URL){
        guard let image = NSImage(contentsOf: url) else {return}
        
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
