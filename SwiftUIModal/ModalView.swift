//
//  ModalView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 7/31/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI
import Combine

/// Environment object responsible for observing/setting the state of the modal view
class ModalViewManager: ObservableObject {
    @Published var position: ModalPosition = .partiallyRevealed
}

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
    
    @EnvironmentObject var modalManager: ModalViewManager
    
    @GestureState var dragState: DragState = .inactive
    @Binding var offset: CGSize
    @Binding var enableFullscreen: Bool
    
    var content: () -> Content
    
    var animation: Animation {
        Animation.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(self.modalManager.position == .fullscreen ? 3:0)
    }
    
    var timer: Timer? {
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            if self.modalManager.position == .open && self.dragState.translation.height == 0 && self.enableFullscreen {
                self.modalManager.position = .fullscreen
            } else {
                timer.invalidate()
            }
        }
    }
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: (self.modalManager.position != .fullscreen) ? drag.translation:.zero)
        }
        .onChanged { self.offset = (self.modalManager.position != .fullscreen) ? $0.translation: .zero}
        .onEnded(onDragEnded)
        
        
        return self.content()
            .background(Color(red: 241/255, green: 241/255, blue: 241/255))
            .mask(RoundedRectangle(cornerRadius: self.cornerRadiusForOffset(), style: .continuous))
            .offset(y: max(0, self.modalManager.position.offsetFromTop() + self.dragState.translation.height))
            .animation(self.dragState.isDragging ? nil : animation)
            .gesture(drag)
            .environmentObject(modalManager)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        
        if modalManager.position == .fullscreen {
            return
        }
        
        // Setting stops
        let higherStop: ModalPosition
        let lowerStop: ModalPosition
        
        // Nearest position for drawer to snap to.
        let nearestPosition: ModalPosition
        
        // Determining the direction of the drag gesture and its distance from the top
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = self.modalManager.position.offsetFromTop() + drag.translation.height
        
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
            self.modalManager.position = lowerStop
        } else if dragDirection < 0 {
            self.modalManager.position = higherStop
        } else {
            self.modalManager.position = nearestPosition
        }
        
        _ = timer
    }
    
    private func cornerRadiusForOffset() -> CGFloat {
        // return (self.position == .fullscreen) ? min((abs(self.dragState.translation.height) * 0.1), 20):20
        // Bug where the min value isn't applied fast enough when the modal view is dragged too quickly
        return 20
    }
}
