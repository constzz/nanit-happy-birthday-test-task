//
//  BirthdayShareButtonStyle.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI

struct BirthdayShareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .regular))
            .padding(.horizontal, 21)
            .padding(.vertical, 11)
            .background(.nanitRed)
            .cornerRadius(32)
            .foregroundColor(configuration.isPressed ? Color.nanitWhite.opacity(0.7) : Color.nanitWhite)
    }
}
