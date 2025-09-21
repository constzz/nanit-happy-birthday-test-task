import SwiftUI

struct BirthdayScreen: View {
    private let viewModel: any BirthdayScreenViewModelProtocol
    
    init(viewModel: any BirthdayScreenViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            viewModel.backgroundColor.ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { viewModel.onBackTapped() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text(viewModel.childName)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(viewModel.age)
                        .font(.system(size: 120, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.ageUnit)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
