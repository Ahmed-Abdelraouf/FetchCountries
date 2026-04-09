//
//  Country.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    let name: CountryName
    let currencies: [String: Currency]?
    let capital: [String]?
    let flags: Flags?
    let cca3: String?
    
    var id: String {
        cca3 ?? UUID().uuidString
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
           return lhs.id == rhs.id
       }
}

struct CountryName: Codable {
    let common: String
}

struct Currency: Codable {
    let name, symbol: String?
}

struct Flags: Codable {
    let png: String?
}
