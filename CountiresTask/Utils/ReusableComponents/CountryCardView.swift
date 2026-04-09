//
//  CountryCardView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

struct CountryCardView<ActionButton: View>: View {
    let country: Country
    var actionButton: ActionButton
    
    var body: some View {
        HStack(spacing: 12) {
            flagImageView
            detailsView
            Spacer()
            actionButton
        }
        .padding(.defaultSpacing(.p12))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cardBorder.opacity(0.5))
        .cornerRadius(.defaultSpacing(.p12))
    }
    
    @ViewBuilder
    private func detailText(_ text: String, isTitle: Bool = false) -> some View {
        Text(text)
            .font(isTitle ? .title2.bold() : .callout)
            .foregroundColor(.white.opacity(isTitle ? 1 : 0.8))
            .multilineTextAlignment(.leading)
    }
    
    private var flagImageView: some View {
        ImageLoaderView(imageURL: country.flags?.svg ?? "")
        .frame(width: 80, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: .defaultSpacing(.p8)))
    }
    
    private var detailsView: some View {
        CountryContentView(country: country)
    }
}

#Preview {
    CountryCardView(
        country: Country(
            name: .init(
                common: "Egypt"
            ),
            currencies: ["EGP" : Currency(name: "Egyptian pound", symbol: "£")],
            capital: ["Cairo"],
            flags: .init(svg: "https://flagcdn.com/eg.svg"),
            cca3: "812"
        ),
        actionButton:  CustomButton(foregroundColor: .red, imageName: "trash") {
            
        }

    )
}
