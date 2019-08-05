//
//  MainView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

struct BackgroundView<Content: View> : View {
    
    @EnvironmentObject var modalManager: ModalViewManager
    
    @State var dragOffset: CGSize = .zero
    @State var enableFullscreen: Bool = false
    
    var content: () -> Content
    
    var body: some View {
        return ZStack(alignment: .bottom) {
            Color.black
            
            // User content
            ZStack {
                Color.white
                self.content()
                    .offset(x: 0, y: 42) // Safe Area Offset
            }
            .mask(RoundedRectangle(cornerRadius: cornerRadiusForOffset(), style: .continuous))
            .scaleEffect(x: scaleForOffset(), y: scaleForOffset(), anchor: .center)
            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            
            // Darkening View
            Rectangle()
                .fill(Color.black)
                .opacity(opacityForOffset())
            
            ModalView(offset: $dragOffset, enableFullscreen: $enableFullscreen) {
                Color.green
            }
            .environmentObject(modalManager)
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    private func isDrawerOpen() -> Bool {
        return [.fullscreen, .open].contains(modalManager.position)
    }
    
    private func scaleForOffset() -> CGFloat {
        if self.dragOffset.height < 0 {
            return isDrawerOpen() ? 0.9:max(1 - abs(self.dragOffset.height*0.0002), 0.9)
        } else {
            return isDrawerOpen() ? min(0.9 + abs(self.dragOffset.height*0.0002), 1):1
        }
    }
    
    private func cornerRadiusForOffset() -> CGFloat {
        if self.dragOffset.height < 0 {
            return isDrawerOpen() ? 15:min(abs(self.dragOffset.height*0.03), 15)
        } else {
            return isDrawerOpen() ? max(15 - abs(self.dragOffset.height*0.03), 0):0
        }
    }
    
    private func opacityForOffset() -> Double {
        if self.dragOffset.height < 0 {
            return isDrawerOpen() ? 0.3:Double(min(abs(self.dragOffset.height*0.001), 0.3))
        } else {
            return isDrawerOpen() ? Double(max(0.3 - abs(self.dragOffset.height*0.001), 0)):0
        }
    }
}
