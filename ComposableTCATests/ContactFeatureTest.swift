//
//  ContactFeatureTest.swift
//  ComposableTCATests
//
//  Created by Daniel Beltran on 30/04/25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import ComposableTCA

@MainActor
struct ContactFeatureTest {
    
    @Test
    func addFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) { state in
            state.destination = .addContact(
                AddContactFeature.State(contact: Contact(id: UUID(0),
                                                         name: ""))
            )
        }
        
        // Emulate user tiping that the name
        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.destination?.modify(\.addContact) {
                $0.contact.name = "Blob Jr."
            }
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(\.destination.addContact.delegate.saveContact, Contact(id: UUID(0), name: "Blob Jr.")) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    @Test
    func addFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob Jr.")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()
        
        store.assert { state in
            state.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
            
            state.destination = nil
        }
    }
    
    @Test
    func deleteContact() async {
        let store = TestStore(
            initialState: ContactsFeature.State(contacts: [
                Contact(id: UUID(0), name: "Blob"),
                Contact(id: UUID(1), name: "Blob Jr.")
            ]
          )
        ) {
            ContactsFeature()
        }
        
        await store.send(.deleteButtonTapped(id: UUID(1))) {
            $0.destination = .alert(.deleteConfirmation(id: UUID(1)))
        }
        
        await store.send(\.destination.alert.confirmDeletion, UUID(1)) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob")
            ]
            
            $0.destination = nil
        }
    }
}
