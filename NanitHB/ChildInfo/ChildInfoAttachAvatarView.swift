//
//  ChildInfoAttachAvatarView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import SwiftUI
import Combine

struct ChildInfoAttachAvatarView: View {
    let picturePublisher: AnyPublisher<FileCached?, Never>
    let showAttachmentsPickerAction: () -> Void
    @State private var picture: Image?
    
    var body: some View {
        Button(action: {
            showAttachmentsPickerAction()
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
        .onReceive(picturePublisher) { fileCached in
            if let data = fileCached?.data, let image = UIImage(data: data) {
                self.picture = Image(uiImage: image)
            } else {
                self.picture = nil
            }
        }
    }
}
