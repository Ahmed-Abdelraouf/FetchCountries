//
//  SnackBarView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//


import SwiftUI

struct ShowSnackBarModifier: ViewModifier {
    let message: String
    let dismissible: Bool
    @Binding var isVisible: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isVisible {
                VStack {
                    Spacer()
                    
                    HStack {
                        Text(message)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(.defaultSpacing(.p10))
                    .padding(.horizontal, .defaultSpacing(.p16))
                    .padding(.bottom, .defaultSpacing(.p16))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        guard dismissible else { return }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isVisible = false
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(.easeInOut, value: isVisible)
    }
}

extension View {
    func showSnackBar(
        message: String,
        isVisible: Binding<Bool>,
        dismissible: Bool = true
    ) -> some View {
        modifier(
            ShowSnackBarModifier(
                message: message,
                dismissible: dismissible,
                isVisible: isVisible
            )
        )
    }
}
