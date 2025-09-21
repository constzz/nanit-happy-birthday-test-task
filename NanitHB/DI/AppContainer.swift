import Foundation
import SwiftUI

@MainActor
final class AppContainer {
    static let shared = AppContainer()
    
    private init() {}
    
    private(set) lazy var childInfoRepository: ChildInfoRepositoryProtocol = {
        ChildInfoRepository(
            userDefaults: .standard,
            persistentStorage: .shared
        )
    }()
    
    private var childInfoViewModel: ChildInfoViewModelProtocol?
    private var birthdayScreenViewModel: BirthdayScreenViewModelProtocol?
    
    func makeChildInfoScreenViewModel(showBirthdayScreenAction: @escaping (ChildInfoViewModel.Output) -> Void) -> ChildInfoViewModelProtocol {
        if let existingViewModel = childInfoViewModel {
            return existingViewModel
        }
        let viewModel = ChildInfoViewModel(
            repository: childInfoRepository,
            showBirthdayScreenAction: showBirthdayScreenAction
        )
        childInfoViewModel = viewModel
        return viewModel
    }
    
    func makeBirthdayScreenViewModel(
        input: BirthdayScreenViewModel.Input,
        onBack: @escaping () -> Void
    ) -> any BirthdayScreenViewModelProtocol {
        if let existingViewModel = birthdayScreenViewModel {
            return existingViewModel
        }
        let viewModel = BirthdayScreenViewModel(
            input: input,
            repository: childInfoRepository,
            onBack: { [weak self] in
                onBack()
                self?.birthdayScreenViewModel = nil
            }
        )
        birthdayScreenViewModel = viewModel
        return viewModel
    }
    
    func resetViewModels() {
        childInfoViewModel = nil
        birthdayScreenViewModel = nil
    }
}
