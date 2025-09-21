import SwiftUI

struct BirthdayScreen: View {
    private let viewModel: any BirthdayScreenViewModelProtocol
    
    init(viewModel: any BirthdayScreenViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image(viewModel.theme.bgImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 20)
                
                AgeView(
                    ageTitleStartText: viewModel.ageTitleStartText,
                    ageTitleEndText: viewModel.ageTitleEndText,
                    ageImage: imageResourceForAge(age: viewModel.ageNumber)
                )
                
                Spacer().frame(height: 15)
                
                HStack {
                    Spacer().frame(minWidth: 50)
                    AvatarView(
                        birthdayTheme: viewModel.theme,
                        picturePublisher: viewModel.imagePublisher,
                        hideCameraIcon: false,
                        action: {
                            
                        })
                    Spacer().frame(minWidth: 50)
                }
                
                Spacer().frame(height: 15)
                
                Image(.nanitLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                
                Spacer()
            }
        }
        .background(viewModel.theme.bgColor)
    }
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .now, avatar: nil, theme: .elephant), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .init(timeInterval: -60000000 * 6, since: .now), avatar: nil, theme: .fox), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .init(timeInterval: -8000000, since: .now), avatar: nil, theme: .pelican), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

private extension BirthdayScreen {
    func imageResourceForAge(age: Int) -> ImageResource {
        switch age {
        case 0: return .zero
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        case 6: return .six
        case 7: return .seven
        case 8: return .eight
        case 9: return .nine
        case 10: return .ten
        case 11: return .eleven
        case 12: return .twelve
        default:
            Logger.error("Returned 0 as fallback for \(age)")
            return .zero
        }
    }
}

private extension BirthdayTheme {
    var bgImage: ImageResource {
        switch self {
        case .pelican:
            return .bgPelican
        case .elephant:
            return .bgElephant
        case .fox:
            return .bgFox
        }
    }
    
    var bgColor: Color {
        switch self {
        case .pelican:
            return .nanitBgBlue
        case .elephant:
            return .nanitBgYellow
        case .fox:
            return .nanitBgGreen
        }
    }
}
