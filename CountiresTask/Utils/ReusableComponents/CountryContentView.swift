//
//  CountryContentView.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import SwiftUI

struct CountryContentView: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: .defaultSpacing(.p10)) {
            Text(country.name.common)
                .font(.title2.bold())
            
            if let capital = country.capital?.first {
                Text("Capital: \(capital)")
            }
            
            if let currency = country.currencies?.values.first {
                Text("Currency: \(currency.name ?? "")")
                if let symbol = currency.symbol {
                    Text("Symbol: \(symbol)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
