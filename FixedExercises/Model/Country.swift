//
//  Country.swift
//  FixedExercises
//
//  Created by Lukas Brezina on 28.09.26.
//

nonisolated struct Countries: Codable {
    let documents: [Country]
}

nonisolated struct Country: Codable {
    let name: String
    let fields: CountryFields
    let createTime: String
    let updateTime: String
}

nonisolated struct CountryFields: Codable {
    let currency: StringValue
    let languages: Languages
    let native: StringValue
    let name: StringValue
    let capital: StringValue
    let continent: StringValue
    let phone: StringValue
}

nonisolated struct StringValue: Codable {
    let stringValue: String
}

nonisolated struct Languages: Codable {
    let arrayValue: LanguageArray
}

nonisolated struct LanguageArray: Codable {
    let values: [StringValue]
}
