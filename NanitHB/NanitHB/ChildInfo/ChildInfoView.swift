//
//  ChildInfoView.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import SwiftUI
import UIKit

struct ChildInfoView: View {
    @State private var name: String = ""
    @State private var birthday: Date? = nil
    @State private var showBirthdayScreen: Bool = false
    @State private var picture: Image? = nil
    @State private var showImagePicker: Bool = false
    @State private var showInlineDatePicker: Bool = false
    
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text(NSLocalizedString("Birthday", comment: "Birthday label"))
                    .font(.headline)
                BirthdayInputField(date: $birthday)
                    .frame(height: 44)
            }
            
            Button(action: {
                showImagePicker = true
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
            }
            .disabled(name.isEmpty || birthday == nil)
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding()
        .sheet(isPresented: $showInlineDatePicker) {
            VStack {
                DatePicker("Select birthday", selection: Binding(get: {
                    birthday ?? Date()
                }, set: { newDate in
                    birthday = newDate
                }), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                Text(DateFormatter.localizedString(from: birthday ?? Date(), dateStyle: .medium, timeStyle: .none))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                Button("Done") {
                    showInlineDatePicker = false
                }
                .padding()
            }
            .padding()
        }
    }
}
