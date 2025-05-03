//
//  AddContactFeature.swift
//  ComposableTCA
//
//  Created by Daniel Beltran on 14/04/25.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
   
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        
        /// Hace que se pueda acceder por path a cada case
        @CasePathable
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case .setName(let name):
                state.contact.name = name
                return .none
            case  .delegate:
                // we should never actully perfom any logic in this case, only the parent should listen for delegate actions and respon accordingly
                return .none
            }
        }
    }
}
