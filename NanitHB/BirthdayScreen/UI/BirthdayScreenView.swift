//
//  BirthdayScreenView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI
import UIKit

struct BirthdayScreenView: View {
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
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
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
                    .frame(height: 240)
                    
                    Spacer().frame(height: 15)
                    
                    Image(.nanitLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Image(viewModel.theme.bgImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                if !snapshotContext.isSnapshotting {
                    Button("Share the news", image: .shareIcon, action: {
                        snapshotContext.takeSnapshot()
                    })
                    .buttonStyle(BirthdayShareButtonStyle())
                    .zIndex(2)
                    .padding(.bottom, 50)
                }
            }
            .background(viewModel.theme.bgColor)
            .safeAreaInset(edge: .top) {
                HStack {
                    Button(action: {
                        viewModel.onBackTapped()
                    }) {
                        ZStack { Image(.backIcon) }
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showShareSheet, onDismiss: { shareImage = nil }) {
            if let image = shareImage {
                ShareSheet(activityItems: [image])
            }
        }
        .overlay {
            if isLoadingSnapshot {
                ZStack {
                    Color.nanitWhite.opacity(0.5)
                        .ignoresSafeArea()
                    ProgressView("Preparing image...")
                        .foregroundStyle(.nanitMainText)
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            if let error = snapshotError {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .blur(radius: 2)
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.nanitWhite)
                            .padding()
                        Button("Dismiss") { snapshotError = nil }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

#Preview {
    BirthdayScreenView(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .now, avatar: nil), theme: .elephant, repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreenView(viewModel: BirthdayScreenViewModel(input: .init(name: "bla bla blabla bla blabla bla blabla bla blabla bla bla", birthdayDate: .init(timeInterval: -60*60*24*364, since: .now), avatar: nil), theme: .fox, repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreenView(viewModel: BirthdayScreenViewModel(input: .init(name: "Cristiano Ronaldo", birthdayDate: .init(timeInterval: -60*60*24*366, since: .now), avatar: nil), theme: .fox, repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

#Preview {
    BirthdayScreenView(viewModel: BirthdayScreenViewModel(input: .init(name: "Username", birthdayDate: .init(timeInterval: -8000000, since: .now), avatar: nil), theme: .pelican, repository: ChildInfoRepository(userDefaults: .standard, persistentStorage: .shared), onBack: {}))
}

private extension BirthdayScreenView {
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
