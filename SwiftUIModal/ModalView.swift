//
//  ModalView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

/// Positions of the`ModalView` relative to the top of the screen.
enum ModalPosition: CGFloat {
    case fullscreen
    case open = 56
    case partiallyRevealed
    case closed
    
    func offsetFromTop() -> CGFloat {
        switch self {
        case .fullscreen:
            return 0
        case .open:
            return 56
        case .partiallyRevealed:
            return UIScreen.main.bounds.height/1.8
        case .closed:
            return UIScreen.main.bounds.height + 42 // Safe-area offset
        }
    }
}

/// `Enum` responsible keeping track of the `DragGesture` state.
/// Lifted from the [official Apple Documentation](https://developer.apple.com/documentation/swiftui/gestures/composing_swiftui_gestures).
enum DragState {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

/// View responsible for presenting content in a modal that slides up from the bottom of the screen.
struct ModalView<Content: View> : View {
    
    @GestureState var dragState: DragState = .inactive
    @Binding var position: ModalPosition
    @Binding var enableFullscreen: Bool
    
    var content: () -> Content
    
    var animation: Animation {
        Animation.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(self.position == .fullscreen ? 3:0)
    }
    
    var timer: Timer? {
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            if self.position == .open {
                self.position = .fullscreen
            } else {
                timer.invalidate()
            }
        }
    }
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
        }
        .onEnded(onDragEnded)
        
        
        return self.content()
            .background(Color(red: 241/255, green: 241/255, blue: 241/255))
            .mask(RoundedRectangle(cornerRadius: (self.position == .fullscreen) ? min(20, abs(self.dragState.translation.height) * 0.1):20, style: .continuous))
            .offset(y: max(0, self.position.offsetFromTop() + self.dragState.translation.height))
            .animation(self.dragState.isDragging ? nil : animation)
            .gesture(drag)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        
        // Setting stops
        let higherStop: ModalPosition
        let lowerStop: ModalPosition
        
        // Nearest position for drawer to snap to.
        let nearestPosition: ModalPosition
        
        // Determining the direction of the drag gesture and its distance from the top
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = self.position.offsetFromTop() + drag.translation.height
        
        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
        if offsetFromTopOfView <= ModalPosition.partiallyRevealed.offsetFromTop() {
            higherStop = .open
            lowerStop = .partiallyRevealed
        } else {
            higherStop = .partiallyRevealed
            lowerStop = .closed
        }
        
        // Determining whether drawer is closest to top or bottom
        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
            nearestPosition = higherStop
        } else {
            nearestPosition = lowerStop
        }
        
        // Determining the drawer's position.
        if dragDirection > 0 {
            self.position = lowerStop
        } else if dragDirection < 0 {
            self.position = higherStop
        } else {
            self.position = nearestPosition
        }
        
        
        if self.position == .open && enableFullscreen {
            _ = timer
        }
    }
}
