import Foundation

final class AppContainer {
    static let shared = AppContainer()
    
    private init() {}
    
    private(set) lazy var childInfoRepository: ChildInfoRepositoryProtocol = {
        ChildInfoRepository(
            userDefaults: .standard,
            persistentStorage: .shared
        )
    }()
    
    func makeChildInfoScreenViewModel(showBirthdayScreenAction: @escaping (ChildInfoViewModel.Output) -> Void) -> ChildInfoViewModelProtocol {
        ChildInfoViewModel(
            repository: childInfoRepository,
            showBirthdayScreenAction: showBirthdayScreenAction
        )
    }
    
    func makeBirthdayScreenViewModel(
        input: BirthdayScreenViewModel.Input,
        onBack: @escaping () -> Void
    ) -> any BirthdayScreenViewModelProtocol {
        BirthdayScreenViewModel(
            input: input,
            repository: childInfoRepository,
            onBack: onBack
        )
    }
}
