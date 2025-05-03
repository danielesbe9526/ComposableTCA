//
//  ContactsFeature.swift
//  ComposableTCA
//
//  Created by Daniel Beltran on 14/04/25.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)

        @CasePathable
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(AddContactFeature.State(contact: Contact(id: self.uuid(),                                             name: "")))
                return .none

            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
                
            case .destination(.presented(.alert(.confirmDeletion(let id)))):
                state.contacts.remove(id: id)
                return .none
                
            case  .destination:
                return .none
                
            case .deleteButtonTapped(let id):
                state.destination = .alert(.deleteConfirmation(id: id))
                
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension ContactsFeature {
    @Reducer
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}

extension ContactsFeature.Destination.State: Equatable {}

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role:.destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}
