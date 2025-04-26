//
//  NumberFactClient.swift
//  TCAArchitecture
//
//  Created by Daniel Beltran on 12/04/25.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fecth: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fecth: { number in
        let (data, _)  = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
        return String(decoding: data, as: UTF8.self)
    })
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
