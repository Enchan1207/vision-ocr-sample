//
//  OcrView.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct OcrView: View {
    @StateObject private var viewModel = OcrViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(nsImage: image).resizable().scaledToFit()
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Drop an image here")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.onDrop(of: [.fileURL], isTargeted: nil) { providers in
            guard let provider = providers.first else { return false }
            
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                guard
                    let data = item as? Data,
                    let url = URL(dataRepresentation: data, relativeTo: nil)
                else {return}
                
                viewModel.didDropFile(url: url)
            }
            
            return true
        }
    }
}
