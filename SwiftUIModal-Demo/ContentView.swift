//
//  ContentView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI
import SwiftUIModal

struct ContentView: View {

    @State var modalState: ModalPosition = .partiallyRevealed

    var body: some View {
        ModalPresenterView(modalState: $modalState, {
            ZStack(alignment: .center) {
                Color.white

                Button("Toggle Modal") {
                    self.modalState.toggle()
                }
            }
        }) {
            Color.red
        }
    }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
