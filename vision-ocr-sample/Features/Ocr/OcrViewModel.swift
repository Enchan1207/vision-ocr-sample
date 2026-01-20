//
//  OcrViewModel.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import AppKit

final class OcrViewModel: ObservableObject {
    @Published var image: NSImage?
    
    let usecase: OcrUsecase
    
    init(usecase: OcrUsecase = .init()) {
        self.usecase = usecase
    }
    
    func didDropFile(url: URL){
        guard let image = NSImage(contentsOf: url) else {return}
        
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    func didClickRecognize(){
        guard let image else { return }
        
        Task {
            await self.usecase.recognize(image)
        }
    }
}
