//
//  ShareableSnapshotView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//


import SwiftUI

struct ShareableSnapshotView<Content: View>: View {
    @Binding var isLoading: Bool
    @Binding var error: String?
    var onSnapshot: (UIImage) -> Void
    var content: (SnapshotContext) -> Content
    
    @State private var isSnapshotting = false
    
    var body: some View {
        ZStack {
            content(SnapshotContext(isSnapshotting: isSnapshotting, takeSnapshot: takeSnapshot))
        }
    }
    
    private func takeSnapshot() {
        isLoading = true
        isSnapshotting = true
        error = nil
        SnapshotGenerator.snapshot(content(SnapshotContext(isSnapshotting: true, takeSnapshot: {}))) { result in
            DispatchQueue.main.async {
                isLoading = false
                isSnapshotting = false
                switch result {
                case .success(let image):
                    onSnapshot(image)
                case .failure(let err):
                    error = err.localizedDescription
                }
            }
        }
    }
    
    struct SnapshotContext {
        let isSnapshotting: Bool
        let takeSnapshot: () -> Void
    }
}
