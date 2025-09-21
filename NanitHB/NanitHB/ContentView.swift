//
//  ContentView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router<AppRoute>()
    private let childInfoRepository = ChildInfoRepository(
        userDefaults: .standard,
        persistentStorage: .shared
    )
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ChildInfoView(
                viewModel:
                    ChildInfoViewModel(
                        repository: childInfoRepository,
                        showBirthdayScreenAction: { router.navigate(to: .birthdayScreen) })
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .birthdayScreen:
                    BirthdayScreen(
                        viewModel:
                            BirthdayScreenViewModel(
                                repository: childInfoRepository,
                                onBack: { router.navigateBack() }))
                }
            }
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
