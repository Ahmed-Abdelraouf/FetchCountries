//
//  CountryDetailsView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

import SwiftUI

struct CountryDetailsView<ActionButton: View>: View {
    let country: Country
    var actionButton: ActionButton
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            closeButton
            flagImageView
            detailsTextViews
            Spacer()
            actionButton
        }
        .padding()
    }
    
    private var flagImageView: some View {
        ImageLoaderView(imageURL: country.flags?.png ?? "")
            .frame(width: 120, height: 84)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay( RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
    }
    
    private var detailsTextViews: some View {
        CountryContentView(country: country)
    }
    
    
    private var closeButton: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.gray.opacity(0.6))
                    .clipShape(Circle())
            }
        }
    }
}
