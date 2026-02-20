import SwiftUI

struct DoctorCard: View {
    @Binding var doctor: User
    @State private var didTimeOut = false

    private let timeOut: TimeInterval = 3
    private var price = 0

    init(doctor: Binding<User>) {
        self._doctor = doctor
        price = minPrice()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 16) {
                avatar
                content

                FavoriteButton(isFavorite: $doctor.isFavorite)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            AppointmentButton(
                action: { },
                receptionTime: doctor.nearestReceptionTime != nil ? true : false
            )
            .padding(.top, 7)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .fill(ColorStyles.grey)
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
        .scaledToFit()
        .foregroundStyle(ColorStyles.grey)
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(doctor.scientificDegreeLabel.capitalized)
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)

            Text("\(doctor.lastName)\n\(doctor.firstName) \(doctor.patronymic)")
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)

            ReviewStars(rating: doctor.rank)

            specializationTitle

            Text("от \(price) ₽")
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var specializationTitle: some View {
        if let specialization = doctor.specialization.last,
           let experience = doctor.workExperience
        {
        Text("\(specialization.name)・" + experience.totalWorkExperience())
        .font(FontStyle.sub2.font)
        .foregroundStyle(ColorStyles.darkGrey)
        } else {
            Text("Педиатр・ 0 лет")
            .font(FontStyle.sub2.font)
            .foregroundStyle(ColorStyles.darkGrey)
        }
    }


}

extension DoctorCard {
    private func minPrice() -> Int {
        var result = Int.max

        result = min(doctor.textChatPrice, doctor.videoChatPrice)

        if let hospital = doctor.hospitalPrice, let home = doctor.homePrice {
            let minGeoPrice = min(hospital, home)
            result = min(result, minGeoPrice)
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

    ContentView(diContainer: DIContainer())
}
