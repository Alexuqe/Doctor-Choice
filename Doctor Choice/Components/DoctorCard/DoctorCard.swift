import SwiftUI

struct DoctorCard: View {
    @Binding var doctor: User
    @Bindable var viewModel: PediatriciansDetailViewModel
    private let appointmentAction: () -> Void

    init(
        doctor: Binding<User>,
        viewModel: PediatriciansDetailViewModel,
        appointmentAction: @escaping () -> Void,
    ) {
        self._doctor = doctor
        self.viewModel = viewModel
        self.appointmentAction = appointmentAction
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
                action: appointmentAction,
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
        .onAppear { viewModel.minPrice(doctor: doctor) }
        .task { await viewModel.startTimeOut() }
    }
}

extension DoctorCard {
    var avatar: some View {
        Group {
            if let image = viewModel.avatarImage(for: doctor) {
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
        .task(id: doctor.id) { await viewModel.loadAvatar(for: doctor) }
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

            Text("от \(viewModel.price) ₽")
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
