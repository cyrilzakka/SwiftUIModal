//
//  ModalManager.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 8/8/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

class ModalManager: ObservableObject {
    @Published var modals: [Modal] = []
    
    func fetchIndex(forID: UUID) -> Int { self.modals.firstIndex { $0.id == forID }! }
    func fetchModal(forID: UUID) -> Modal? { self.modals.first { $0.id == forID } }
    func isFirst(id: UUID) -> Bool { return self.modals.first!.id == id }
    
    func fetchNext(forID: UUID) -> Modal? {
        let index = fetchIndex(forID: forID)
        if self.modals.indices.contains(index + 1) {
            return self.modals[index + 1]
        } else {
            return nil
        }
    }
    
    func fetchContent() {
        modals =
            [Modal(content: AnyView(
                ZStack {
                    Color.green
                    Button(action: {
                        self.modals[1].position = .partiallyRevealed
                    }, label: {
                        Text("Add modal")
                    })
                }
            )),
             Modal(content: AnyView(
                ZStack {
                    Color.red
                    Button(action: {
                        self.modals[2].position = .partiallyRevealed
                    }, label: {
                        Text("Add modal")
                    })
                }
                
             ), position: .partiallyRevealed),
             Modal(content: AnyView(
                ZStack {
                    Color.orange
                    Button(action: {
                        self.modals[3].position = .partiallyRevealed
                    }, label: {
                        Text("Add modal")
                    })
                }
                
             ), position: .closed),
             Modal(content: AnyView(Color.purple), position: .closed)
        ]
    }
}
