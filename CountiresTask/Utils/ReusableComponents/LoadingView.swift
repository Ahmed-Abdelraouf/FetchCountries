//
//  LoadingView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI


struct ShowLoaderModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
               
            if isLoading {
                LoadingView()
            }
        }
    }
}
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
        }
    }
}
extension View {
    func showLoader(isLoading: Binding<Bool>) -> some View {
        self.modifier(ShowLoaderModifier(isLoading: isLoading))
    }
}

