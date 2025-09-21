//
//  AgeView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI

struct AgeView: View {
    let ageTitleStartText: String
    let ageTitleEndText: String
    let ageImage: ImageResource
    
    var body: some View {
        Text(ageTitleStartText)
            .font(.system(size: 21.0, weight: .medium))
            .lineLimit(2)
            .multilineTextAlignment(.center)
        Spacer().frame(height: 13)
        HStack {
            Image(.swirlsLeft)
            Image(ageImage).padding(.horizontal, 22)
            Image(.swirlsRight)
        }
        Spacer().frame(height: 14)
        Text(ageTitleEndText)
            .font(.system(size: 21.0))
            .multilineTextAlignment(.center)
    }
}

#Preview {
    AgeView(ageTitleStartText: "Username", ageTitleEndText: "MONTHS", ageImage: .zero)
}

#Preview {
    AgeView(ageTitleStartText: "Very long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long username here provided", ageTitleEndText: "MONTHS", ageImage: .twelve)
}

