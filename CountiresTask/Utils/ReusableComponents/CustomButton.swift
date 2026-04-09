//
//  CustomButton.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//


import SwiftUI

struct CustomButton: View {
    var backgroundColor: Color = .clear
    var foregroundColor: Color = .clear
    var label: String?
    var imageName: String?
    var width: CGFloat = 24
    var height: CGFloat = 24
    var cornerRadius: CGFloat?
    var isFullWidth: Bool = false
    let action: () -> Void
    
    private var fullScreenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        Button(action: action) {
            if let imageName = imageName {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(foregroundColor.opacity(0.6))
                    
            }
            
            if let label = label {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: isFullWidth ? fullScreenWidth - 48 : width, height: height)
        .background(backgroundColor.opacity(0.6))
        .cornerRadius(cornerRadius ?? 0)
    }
}


#Preview {
    CustomButton(imageName: ""){}
}
