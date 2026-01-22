//
//  OcrView.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct OcrView: View {
  @StateObject private var viewModel: OcrViewModel

  init(engine: OcrEngine) {
    _viewModel = StateObject(wrappedValue: .init(engine: engine))
  }

  var body: some View {
    VStack {
      switch viewModel.state {
      case .empty:
        VStack(spacing: 8) {
          Image(systemName: "photo")
            .font(.largeTitle)
            .foregroundColor(.secondary)
          Text("Drop an image here")
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      case .imageLoaded(let image):
        VStack(spacing: 8) {
          Image(nsImage: image).resizable().scaledToFit()
          Button("Run OCR") {
            viewModel.didClickRecognize()
          }
        }

      case .textRecognizing(let image):
        VStack(spacing: 8) {
          Image(nsImage: image).resizable().scaledToFit()
          Button("Run OCR") {}.disabled(true)
        }

      case .textRecognized(let image, let results):
        VStack(spacing: 8) {
          Image(nsImage: image).resizable().scaledToFit()
          Button("Run OCR") {
            viewModel.didClickRecognize()
          }
        }

      case .error:
        Text("An error occurred").foregroundColor(.secondary)
      }
    }.onDrop(of: [.fileURL], isTargeted: nil) { providers in
      guard let provider = providers.first else { return false }

      provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
        guard
          let data = item as? Data,
          let url = URL(dataRepresentation: data, relativeTo: nil)
        else { return }

        viewModel.didDropFile(url: url)
      }

      return true
    }
  }
}
