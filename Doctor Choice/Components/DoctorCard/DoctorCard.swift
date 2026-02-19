import SwiftUI

struct DoctorCard: View {
    @Binding var doctor: User
    @State private var didTimeOut = false
    private let timeOut: TimeInterval = 3

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 16) {
                avatar
                content

                FavoriteButton(isFavorite: $doctor.isFavorite)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .task {
           await startTimeOut()
        }
    }
}

extension DoctorCard {
    var avatar: some View {
        AsyncImage(url: URL(string: doctor.avatar ?? "")) { phase in
            switch phase {
                case .empty:
                    if didTimeOut {
                        defaultImage
                    } else {
                        ProgressView()
                    }
                case .success(let image):
                    image
                    .resizable()
                    .scaledToFill()

                case .failure:
                    defaultImage
                @unknown default:
                    defaultImage
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(.circle)
    }

    var defaultImage: some View {
        Image(systemName: "person.crop.circle.badge.exclamationmark")
        .resizable()
        .scaledToFill()
        .foregroundStyle(ColorStyles.grey)
    }

    var content: some View {
        VStack(alignment: .leading) {
            Text("\(doctor.lastName)\n\(doctor.firstName + doctor.patronymic)")
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)

            ReviewStars(rating: doctor.rank)

            if let specialization = doctor.specialization.first,
               let experience = doctor.workExperience
            {
            Text("\(specialization.name)・" + experience.totalWorkExperience())
            .font(FontStyle.sub2.font)
            .foregroundStyle(ColorStyles.darkGrey)
            }

            Text("от \(minPrice()) ₽")
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension DoctorCard {
    private func minPrice() -> Int {
        var result = 0
        var minChatPrice = 0

        if doctor.textChatPrice > 0 || doctor.videoChatPrice > 0 {
            minChatPrice = min(doctor.textChatPrice, doctor.videoChatPrice)
        }

        if let hospital = doctor.hospitalPrice, let home = doctor.homePrice {
            if hospital > 0 || home > 0 {
                let minGeoPrice = min(hospital, home)
                result = min(minChatPrice, minGeoPrice)
            }
        }

        return result
    }

    private func startTimeOut() async {
        try? await Task.sleep(nanoseconds: UInt64(timeOut * 1_000_000_000))

        if !Task.isCancelled {
            didTimeOut = true
        }
    }
}

#Preview {
    @Previewable @State var viewModel = PediatriciansViewModel(
        networkService: NetworkService(cache: CacheService())
    )

    ContentView(viewModel: viewModel)
}
