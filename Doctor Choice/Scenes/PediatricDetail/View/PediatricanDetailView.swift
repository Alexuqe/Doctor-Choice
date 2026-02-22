import SwiftUI

struct PediatricianDetailView: View {
    @Bindable var viewModel: PediatriciansDetailViewModel
    @Binding var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            userHeader
            userInfo
            
            PriceButton(price: viewModel.price, action: {
                viewModel.openPriceScreen(for: user)
            })
            .padding(.bottom, 4)

            Text("\(user)")
            .font(FontStyle.sub2.font)
            .foregroundStyle(ColorStyles.black)

            Spacer()

            AppointmentButton(action: { }, receptionTime: user.nearestReceptionTime != nil ? true : false)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle(user.specialization.last?.name ?? "")
    }
}

extension PediatricianDetailView {
    var userHeader: some View {
        HStack(spacing: 16) {
            avatar

            Text("\(user.lastName)\n\(user.firstName) \(user.patronymic)")
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)
        }
    }

    var avatar: some View {
        Group {
            if let image = viewModel.avatarImage(for: user) {
                Image(uiImage: image)
                .resizable()
                .scaledToFill()
            } else if viewModel.didTimeOut {
                defaultImage
            } else {
                ProgressView()
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(.circle)
        .task(id: user.id) { await viewModel.loadAvatar(for: user) }
    }

    var defaultImage: some View {
        Image(systemName: "person.crop.circle.badge.exclamationmark")
        .resizable()
        .scaledToFit()
        .foregroundStyle(ColorStyles.grey)
    }

    var userInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            clockTitle
            categoryTitle
            educationTitle
            clinicTitle
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var clockTitle: some View {
        if let experience = user.workExperience {
            DoctorDetailLabel(systemImage: "clock", text: "Опыт работы: \(experience.totalWorkExperience())")
        } else {
            DoctorDetailLabel(systemImage: "clock", text: "Педиатр・ 0 лет")
        }
    }

    var categoryTitle: some View {
        DoctorDetailLabel(systemImage: "cross.case", text: user.categoryLabel)
    }

    var educationTitle: some View {
        DoctorDetailLabel(systemImage: "graduationcap", text: user.educationTypeLabel?.name)
    }

    var clinicTitle: some View {
        DoctorDetailLabel(systemImage: "location", text: user.workExperience?.last?.organization)
    }
}

#Preview {
    @Previewable @State var userVM = PediatriciansViewModel(networkService: NetworkService(cache: CacheService()), router: Router())

    @Previewable @State var user: User = User(
        id: UUID(),
        firstName: "asdasdasd",
        patronymic: "asdasdadsasd",
        lastName: "asdasdasd",
        specialization: [Specialization(id: 1, name: "Pediator")],
        ratings: [],
        ratingsRating: 4.5,
        seniority: 4,
        textChatPrice: 200,
        videoChatPrice: 300,
        homePrice: nil,
        hospitalPrice: nil,
        avatar: "https://media.istockphoto.com/id/1292777576/photo/doctor-clicking-on-a-laptop-before-her.jpg?s=1024x1024&w=is&k=20&c=gaIXOmSFv4YDK6UCyK_5m1OQvxhhkvpOzn46ovO2ALk=",
        nearestReceptionTime: Date(timeIntervalSince1970: 1700490600),
        freeReceptionTime: [],
        educationTypeLabel: nil,
        higherEducation: [],
        workExperience: [WorkExperience(
            id: 2,
            organization: "asdasd",
            position: "asdasd",
            startDate: 1698796800,
            endDate: 1700092800,
            untilNow: false
        )],
        rank: 4,
        scientificDegreeLabel: "доктор медицинских наук",
        categoryLabel: "Первая",
        isFavorite: false
    )

    PediatricianDetailView(
        viewModel: PediatriciansDetailViewModel(imageLoadService: ImageLoadingService(cache: ImageCacheService(), networkLoader: ImageNetworkLoader()), router: Router()),
        user: $user
    )
}
