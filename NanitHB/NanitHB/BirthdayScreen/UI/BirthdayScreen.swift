import SwiftUI

struct BirthdayScreen: View {
    private let viewModel: any BirthdayScreenViewModelProtocol
    
    init(viewModel: any BirthdayScreenViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background
            Image(viewModel.theme.bgImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                AgeView(
                    ageTitleStartText: viewModel.ageTitleStartText,
                    ageTitleEndText: viewModel.ageTitleEndText,
                    ageImage: ._0
                )
                
                Spacer()
                
                // Nanit logo
                Image("nanit_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.bottom, 15)
            }
            .padding(.top, 50)
        }
        .navigationBarBackButtonHidden(true)
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
}
