//
//  ContentView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ChildInfoView(viewModel: ChildInfoViewModel(repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared)))
    }
}

#Preview {
    ContentView()
}
