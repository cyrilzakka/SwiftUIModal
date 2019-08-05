//
//  ContentView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
     @EnvironmentObject var modalManager: ModalViewManager
    
    var body: some View {
        BackgroundView {
            Color.white
        }
        .environmentObject(modalManager)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
