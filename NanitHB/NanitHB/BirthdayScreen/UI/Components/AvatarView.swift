//
//  AvatarView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 21.09.2025.
//

import Foundation
import SwiftUI
import Combine

struct AvatarView: View {
    
    private enum Constants {
        static let iconSize: CGFloat = 36.0
        static let cameraIconAngle: Double = 45.0
    }
    
    let birthdayTheme: BirthdayTheme
    let picturePublisher: AnyPublisher<FileCached?, Never>
    let hideCameraIcon: Bool
    let action: () -> Void
    
    @State private var picture: Image?
    
    var body: some View {
        ZStack {
            if let picture {
                picture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .layoutPriority(-1)
                    .clipShape(Circle())
            } else {
                Image(birthdayTheme.placeholderImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
            VStack {
                Image(birthdayTheme.cameraIconImage).resizable().scaledToFit()
                    .frame(width: Constants.iconSize, height: Constants.iconSize, alignment: Alignment.top)
                    .rotationEffect(Angle(degrees: -Constants.cameraIconAngle))
                    .offset(y: -Constants.iconSize / 2.0)
                Spacer()
            }
            .rotationEffect(Angle(degrees: Constants.cameraIconAngle))
            .opacity(hideCameraIcon ? 0.0 : 1.0)
            .onTapGesture { self.action() }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .onReceive(picturePublisher) { fileCached in
            if let data = fileCached?.data, let image = UIImage(data: data) {
                self.picture = Image(uiImage: image)
            } else {
                self.picture = nil
            }
            
        }
    }
}


private extension BirthdayTheme {
    var placeholderImage: ImageResource {
        switch self {
        case .pelican:
            return .avatarChildPlaceholderBlue
        case .elephant:
            return .avatarChildPlaceholderYellow
        case .fox:
            return .avatarChildPlaceholderGreen
        }
    }
    
    var cameraIconImage: ImageResource {
        switch self {
        case .pelican:
            return .addPhotoBlue
        case .elephant:
            return .addPhotoYellow
        case .fox:
            return .addPhotoGreen
        }
    }
}
