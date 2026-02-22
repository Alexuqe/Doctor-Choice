import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: PediatriciansViewModel
    @Bindable var detailViewModel: PediatriciansDetailViewModel

    @Namespace private var animationNamespace

    var body: some View {
        VStack(spacing: 15) {
            Text("Педиатры")
            .font(FontStyle.h3.font)
            .foregroundStyle(ColorStyles.black)

            searchField
            segmentController
            .padding(.vertical, 2)
            cards
        }
        .padding()
    }
}

extension ContentView {
    var searchField: some View {
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
    }

    var segmentController: some View {
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
                .stroke(ColorStyles.grey, lineWidth: 1)
            }
    }

    var cards: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.visible.enumerated(), id: \.element.id) { index, doctor in
                    DoctorCard(
                        doctor: viewModel.binding(for: doctor),
                        viewModel: detailViewModel,
                        appointmentAction: { viewModel.openDoctorDetail(for: doctor) }
                    )
                    .opacity(viewModel.appearedIDs.contains(doctor.id) ? 1 : 0)
                    .offset(y: viewModel.appearedIDs.contains(doctor.id) ? 0 : 10)
                    .animation(.easeOut(duration: 0.25)
                    .delay(0.1) , value: viewModel.appearedIDs)
                    .onAppear { viewModel.handleAppear(index: index, doctor: doctor) }
                }
            }

            if viewModel.isLoading { ProgressView().padding(16) }
        }
        .refreshable {
            viewModel.appearedIDs.removeAll()
            await viewModel.refresh()
        }
        .contentMargins(.bottom, 60)
    }
}

#Preview {
    @Previewable @State var viewModel = PediatriciansViewModel(
        networkService: NetworkService(cache: CacheService()), router: Router()
    )

    ContentView(
        viewModel: viewModel,
        detailViewModel: PediatriciansDetailViewModel(
            imageLoadService: ImageLoadingService(
                cache: ImageCacheService(),
                networkLoader: ImageNetworkLoader()
            ), router: Router()
        )
    )
}
