//
//  AppFeatureTest.swift
//  ComposableTCATests
//
//  Created by Daniel Beltran on 14/04/25.
//

import Testing
import ComposableArchitecture

@testable import ComposableTCA


struct AppFeatureTest {

    @Test
    func incrementInFirstTab() async throws {
        let store = await TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }

}
