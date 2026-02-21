import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: PediatriciansViewModel
    @State private var appearedIDs: Set<User.ID> = []

    @Namespace private var animationNamespace

    var body: some View {
        VStack(spacing: 15) {
            Text("Педиатры")
            .font(FontStyle.h3.font)
            .foregroundStyle(ColorStyles.black)

            HStack {
                Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(.gray.opacity(0.6))

                TextField(
                    "Поиск",
                    text: Binding(
                        get: { viewModel.searchText },
                        set: { viewModel.searchText = $0 }
                    )
                )
                .textInputAutocapitalization(.never)
            }
            .padding(9)
            .background {
                RoundedRectangle(cornerRadius: 8)
                .strokeBorder(ColorStyles.grey, lineWidth: 1)
            }

            SegmentedControl(
                selectedTab: $viewModel.selectedSegment,
                tabs: viewModel.tabs) { size in
                    Capsule()
                    .fill(ColorStyles.pink)
                    .padding(8)
                    .frame(height: size.height)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background {
                    Capsule()
                    .fill(ColorStyles.white)
                    .stroke(ColorStyles.grey.opacity(0.3), lineWidth: 1)
                }

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.visible.enumerated(), id: \.element.id) { index, doctor in
                        DoctorCard(doctor: binding(for: doctor))
                        .opacity(appearedIDs.contains(doctor.id) ? 1 : 0)
                        .offset(y: appearedIDs.contains(doctor.id) ? 0 : 10)
                        .animation(.easeOut(duration: 0.25)
                        .delay(0.1) , value: appearedIDs)
                        .onAppear {
                            handleAppear(index: index, doctor: doctor)
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView().padding(16)
                }
            }
            .refreshable {
                appearedIDs.removeAll()
                await viewModel.refresh()
            }
            .contentMargins(.bottom, 40)

            Spacer()
        }
        .padding()
    }
}

extension ContentView {
    private func binding(for doctor: User) -> Binding<User> {
        Binding(
            get: { viewModel.visible.first { $0.id == doctor.id } ?? doctor },
            set: { updated in
                if let index = viewModel.visible.firstIndex(where: { $0.id == doctor.id }) {
                    viewModel.visible[index] = updated
                }
            }
        )
    }

    private func handleAppear(index: Int, doctor: User) {
        if !appearedIDs.contains(doctor.id) {
            appearedIDs.insert(doctor.id)
        }

        let threshold = viewModel.visible.count - 2

        if index == threshold {
            viewModel.loadMoreDebounced()
        }

    }
}

#Preview {
    @Previewable @State var viewModel = PediatriciansViewModel(
        networkService: NetworkService(cache: CacheService()), router: Router()
    )

    ContentView(viewModel: viewModel)
}
