//
//  ShareSheet.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//


import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
