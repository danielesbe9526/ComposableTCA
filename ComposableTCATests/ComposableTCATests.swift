//
//  ComposableTCATests.swift
//  ComposableTCATests
//
//  Created by Daniel Beltran on 14/04/25.
//

import Testing
import ComposableArchitecture

@testable import ComposableTCA

struct ComposableTCATests {

    @Test
    func basics() async throws {
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    @Test
    func timer() async throws {
        let clock = TestClock()
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
//        await clock.advance(by: .seconds(1))
//        await store.receive(\.timerTick) {
//            $0.count = 1
//        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    @Test
    func numberFact() async throws {
        let store = await TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fecth = { _ in
                "is a good number."
            }
        }

        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }

        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "is a good number."
        }
    }
}
