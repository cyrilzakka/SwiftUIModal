//
//  MainView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

struct MainView<Content: View> : View {
    
    @State var modalPosition: ModalPosition = .partiallyRevealed
    @State var enableFullscreen: Bool = true
    
    var content: () -> Content
    
    var body: some View {
        return ZStack(alignment: .bottom) {
            Color.black
            
            // User content
            self.content()
                .mask(RoundedRectangle(cornerRadius: isDrawerOpen() ? 15:0, style: .continuous))
                .scaleEffect(x: isDrawerOpen() ?  0.9:1, y: isDrawerOpen() ?  0.9:1, anchor: .center)
                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            
            // Darkening View
            Rectangle()
                .fill(Color.black)
                .opacity(isDrawerOpen() ? 0.3:0)
            
            ModalView( position: $modalPosition, enableFullscreen: $enableFullscreen) {
                Color.red
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    private func isDrawerOpen() -> Bool {
        return [.fullscreen, .open].contains(modalPosition)
    }
}

