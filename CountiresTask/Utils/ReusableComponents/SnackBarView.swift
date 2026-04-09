//
//  SnackBarView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//


import SwiftUI

struct SnackBarView: View {
    let message: String
    var dismissible: Bool = true
    @Binding var isVisible: Bool
    
    var body: some View {
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
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                if dismissible {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }
            }
        }
    }
}
