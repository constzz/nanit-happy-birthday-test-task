import SwiftUI
import UIKit

struct BirthdayScreen: View {
    private let viewModel: any BirthdayScreenViewModelProtocol
    private let attachmentsPicker = AttachmentsPickerPresenter()
    
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    @State private var isLoadingSnapshot = false
    @State private var snapshotError: String?
    
    init(viewModel: any BirthdayScreenViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ShareableSnapshotView(
            isLoading: $isLoadingSnapshot,
            error: $snapshotError,
            onSnapshot: { image in
                shareImage = image
                showShareSheet = true
            }
        ) { snapshotContext in
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
                    .padding(.horizontal, 40)
                    Spacer().frame(height: 15)
                    
                    HStack {
                        Spacer().frame(width: 50)
                        AvatarView(
                            birthdayTheme: viewModel.theme,
                            picturePublisher: viewModel.imagePublisher,
                            hideCameraIcon: snapshotContext.isSnapshotting,
                            action: {
                                attachmentsPicker.present(
                                    allowedAttachments: [
                                        .library(allowedMediaTypes: [.photo]),
                                        .camera(allowedMediaTypes: [.photo], camera: .rear, allowsEditing: true)
                                    ],
                                    limit: 1,
                                    onPicked: { files in
                                        guard let fileCached = files.first else { return }
                                        viewModel.setImage(file: fileCached)
                                    }
                                )
                            }
                        )
                        Spacer().frame(width: 50)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    Image(.nanitLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                    
                    Spacer()
                    
                    if !snapshotContext.isSnapshotting {
                        Button("Share the news", image: .shareIcon, action: {
                            snapshotContext.takeSnapshot()
                        })
                        .buttonStyle(BirthdayShareButtonStyle())
                        
                        Spacer().frame(height: 53)
                    }
                }
            }
            .background(viewModel.theme.bgColor)
        }
        .sheet(isPresented: $showShareSheet, onDismiss: { shareImage = nil }) {
            if let image = shareImage {
                ShareSheet(activityItems: [image])
            }
        }
        .overlay {
            if isLoadingSnapshot {
                ProgressView("Preparing image...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
            if let error = snapshotError {
                VStack {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                    Button("Dismiss") { snapshotError = nil }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.2))
            }
        }
    }
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .now, avatar: nil, theme: .elephant), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "bla bla blabla bla blabla bla blabla bla blabla bla bla", birthdayDate: .init(timeInterval: -60*60*24*364, since: .now), avatar: nil, theme: .fox), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreen(viewModel: BirthdayScreenViewModel(input: .init(name: "Cristiano Ronaldo", birthdayDate: .init(timeInterval: -60*60*24*366, since: .now), avatar: nil, theme: .fox), repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
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
