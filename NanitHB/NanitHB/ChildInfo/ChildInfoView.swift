//
//  ChildInfoView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI
import Combine

struct ChildInfoView: View {
    private var viewModel: any ChildInfoViewModelProtocol
    
    @State private var name: String = ""
    @State private var birthday: Date? = nil
    @State private var picture: Image? = nil
    @State private var showImagePicker: Bool = false
    @State private var canShowBirthdayScreen: Bool = false
    @StateObject private var attachmentsPicker = AttachmentsPickerPresenter()
    
    @State private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: any ChildInfoViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(NSLocalizedString("Nanit", comment: "App title"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(NSLocalizedString("Name", comment: "Name label"))
                    .font(.headline)
                TextField(NSLocalizedString("Enter name", comment: "Name input placeholder"), text: $name)
                    .onChange(of: name) { _, newName in viewModel.setName(newName) }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.name)
                
                Text(NSLocalizedString("Birthday", comment: "Birthday label"))
                    .font(.headline)
                BirthdayInputField(date: $birthday, maxDate: .now)
                    .onChange(of: birthday) { _, newBirthday in
                        viewModel.setBirthday(newBirthday)
                    }
                    .frame(height: 44)
            }
            ChildInfoAttachAvatarView(picturePublisher: viewModel.picturePublisher, showAttachmentsPickerAction: {
                attachmentsPicker.present(
                    allowedAttachments: [
                        .library(allowedMediaTypes: [.photo]),
                        .camera(allowedMediaTypes: [.photo], camera: .rear, allowsEditing: true)
                    ],
                    limit: 1,
                    onPicked: { files in
                        guard let fileCached = files.first else { return }
                        viewModel.setPicture(fileCached)
                    })
            })
            Button(NSLocalizedString("Show birthday screen", comment: "Show birthday screen button")) {
                viewModel.showBirthdayScreen()
            }
            .disabled(!canShowBirthdayScreen)
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding()
        .safeAreaPadding(.all)
        .onReceive(viewModel.canShowBirthdayScreenPublisher) { self.canShowBirthdayScreen = $0 }
        .onReceive(viewModel.birthdayPublisher) { self.birthday = $0 }
        .onReceive(viewModel.namePublisher) { self.name = $0 }
    }
}
