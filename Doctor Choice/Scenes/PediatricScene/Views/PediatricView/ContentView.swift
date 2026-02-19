import SwiftUI

struct ContentView: View {
    @State var viewModel: PediatriciansViewModel
    @State var tfText: String = ""

    var body: some View {
        VStack {
            Text("Педиатры")
            .font(FontStyle.h3.font)
            .foregroundStyle(ColorStyles.black)

            HStack {
                Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(.gray.opacity(0.6))

                TextField("Поиск", text: $tfText)
            }
            .padding(9)
            .background {
                RoundedRectangle(cornerRadius: 8)
                .strokeBorder(ColorStyles.grey, lineWidth: 1)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var viewModel = PediatriciansViewModel(
        networkService: NetworkService(cache: CacheService())
    )

    ContentView(viewModel: viewModel)
}
