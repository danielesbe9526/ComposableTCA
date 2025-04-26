//
//  ComposableTCAApp.swift
//  ComposableTCA
//
//  Created by Daniel Beltran on 14/04/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableTCAApp: App {
//    static let store = Store(initialState: CounterFeature.State()) {
//        CounterFeature()
//            ._printChanges()
//    }
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    static let storeC = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
    }
                             
    var body: some Scene {
        WindowGroup {
//            ContentView(store: ComposableTCAApp.store)
            AppView(store: ComposableTCAApp.store, storeContacts: ComposableTCAApp.storeC)
        }
    }
}
