//
//  ModalView.swift
//  SwiftUIModal
//
//  Created by Cyril Zakka on 8/8/19.
//  Copyright © 2019 Cyril Zakka. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    
    @EnvironmentObject var modalManager: ModalManager
    @Binding var currentModal: Modal
    
    var isActive: Bool {
        if let nextModal = modalManager.fetchNext(forID: currentModal.id) {
            return [.partiallyRevealed, .closed].contains(nextModal.position) && !self.modalManager.isFirst(id: currentModal.id)
        } else {
            return [.open, .partiallyRevealed, .closed, .fullscreen].contains(self.currentModal.position)
        }
    }
    
    var body: some View {
        return ModifiedContent(content: currentModal.content, modifier: ModalModifier(isActive: isActive, position: $currentModal.position, offset: $currentModal.dragOffset, isFullscreenEnabled: currentModal.isFullscreenEnabled, modalID: currentModal.id))
    }
}
