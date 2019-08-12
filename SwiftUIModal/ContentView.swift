//
//  ContentView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
        return ZStack {
            ForEach($modalManager.modals) { modal in
                ModalView(currentModal: modal).environmentObject(self.modalManager)
            }
        }.onAppear(perform: {self.modalManager.fetchContent()})
    }
}
