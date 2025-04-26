//
//  AppView.swift
//  ComposableTCA
//
//  Created by Daniel Beltran on 14/04/25.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    let storeContacts: StoreOf<ContactsFeature>
    
    var body: some View {
        TabView {
            ContentView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }
            
            ContentView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
            
            ContactsView(store: storeContacts)
                .tabItem {
                    Text("Contacts")
                }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
    }), storeContacts: Store(initialState: ContactsFeature.State(), reducer: {
        ContactsFeature()
    }))
}
