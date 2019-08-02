//
//  MainView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

public struct ModalPresenterView<Content: View, ModalContent: View> : View {
    
    @State public var dragOffset: CGSize = .zero
    @Binding public var modalPosition: ModalPosition
    @State public var enableFullscreen: Bool = true

    public init(modalState: Binding<ModalPosition>,
                _ content: @escaping () -> Content,
                _ modalContent: @escaping () -> ModalContent) {
        self._modalPosition = modalState
        self.content = content
        self.modalcontent = modalContent
    }
    
    var content: () -> Content
    var modalcontent: () -> ModalContent
    
    public var body: some View {
        return ZStack(alignment: .bottom) {
            Color.black
            
            // User content
            self.content()
                .mask(RoundedRectangle(cornerRadius: cornerRadiusForOffset(), style: .continuous))
                .scaleEffect(x: scaleForOffset(), y: scaleForOffset(), anchor: .center)
                .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            
            // Darkening View
            Rectangle()
                .fill(Color.black)
                .opacity(opacityForOffset())
            
            ModalView(offset: $dragOffset, position: $modalPosition, enableFullscreen: $enableFullscreen) {
                self.modalcontent()
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    private func isDrawerOpen() -> Bool {
        return [.fullscreen, .open].contains(modalPosition)
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
            return isDrawerOpen() ? 15:max(abs(self.dragOffset.height*0.01), 15)
        } else {
            return isDrawerOpen() ? min(15 - abs(self.dragOffset.height*0.01), 0):0
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

