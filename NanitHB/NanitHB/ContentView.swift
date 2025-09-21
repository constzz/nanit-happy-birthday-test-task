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
                        showBirthdayScreenAction: { output in
                            router.navigate(to: .birthdayScreen(.init(name: output.name, birthdayDate: output.birthday, avatar: output.avatar, theme: .allCases.randomElement() ?? .elephant)))
                        })
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .birthdayScreen(let input):
                    BirthdayScreen(
                        viewModel:
                            BirthdayScreenViewModel(
                                input: input,
                                repository: childInfoRepository,
                                onBack: { router.navigateBack() }
                            ))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
