//
//  OcrTextView.swift
//  vision-ocr-sample
//
//  Created by enchantcode on 2026/01/22.
//

import SwiftUI

struct OcrTextView: View {
    let text: String
    let boundingBox: CGRect
    let imageSize: CGSize
    
    var body: some View {
        let rect = convertRect()
        
        Text(text)
            .background(.black.opacity(0.8))
            .foregroundColor(.white)
            .position(x: rect.midX, y: rect.midY)
            .frame(width: rect.width, height: rect.height)
    }
    
    /// 検出領域の座標系をSwiftUI座標系に変換する
    private func convertRect() -> CGRect{
        let size = imageSize.applying(.init(scaleX: boundingBox.width, y: boundingBox.height))
        let origin = CGPoint(x: boundingBox.origin.x * imageSize.width, y: (1-boundingBox.origin.y-boundingBox.height)*imageSize.height)
        
        return .init(origin: origin, size: size)
    }
}
