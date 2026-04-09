//
//  ImageLoaderView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    var imageURL: String
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        WebImage(url: URL(string: imageURL), options: [.refreshCached])
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: resizingMode)
            .allowsHitTesting(false)
            .clipped()
    }
}
#Preview {
    ImageLoaderView(imageURL: "https://flagcdn.com/eg.svg")
}
