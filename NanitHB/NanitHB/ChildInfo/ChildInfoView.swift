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
    @State private var showBirthdayScreen: Bool = false
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
            
            Button(action: {
                attachmentsPicker.present(allowedAttachments: [
                    .library(allowedMediaTypes: [.photo]),
                    .camera(allowedMediaTypes: [.photo], camera: .rear, allowsEditing: true)
                ], onPicked: { images in
                    if let image = images.first {
                        viewModel.setPicture(image)
                    }
                })
            }) {
                HStack {
                    if let picture = picture {
                        picture
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo")
                            .font(.title)
                    }
                    Text(NSLocalizedString("Picture", comment: "Picture button label"))
                }
            }
            .buttonStyle(.bordered)
            Button(NSLocalizedString("Show birthday screen", comment: "Show birthday screen button")) {
                showBirthdayScreen = true
                viewModel.setShowBirthdayScreen(true)
            }
            .disabled(!canShowBirthdayScreen)
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding()
        .onReceive(viewModel.picturePublisher) { self.picture = $0 }
        .onReceive(viewModel.showBirthdayScreenPublisher) { self.showBirthdayScreen = $0 }
        .onReceive(viewModel.showImagePickerPublisher) { self.showImagePicker = $0 }
        .onReceive(viewModel.canShowBirthdayScreenPublisher) { self.canShowBirthdayScreen = $0 }
        .onReceive(viewModel.birthdayPublisher) { self.birthday = $0 }
        .onReceive(viewModel.namePublisher) { self.name = $0 }
    }
}
