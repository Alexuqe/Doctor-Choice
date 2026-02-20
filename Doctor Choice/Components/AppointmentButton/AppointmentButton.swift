import SwiftUI

struct AppointmentButton: View {
    private var action: () -> Void
    private let receptionTime: Bool

    init(action: @escaping () -> Void, receptionTime: Bool) {
        self.action = action
        self.receptionTime = receptionTime
    }

    var body: some View {
        Button(action: action) {
            Text(receptionTime ? "Записаться" : "Нет свободного расписания")
            .font(FontStyle.h4.font)
            .foregroundStyle(receptionTime ? ColorStyles.white : ColorStyles.black)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(receptionTime ? ColorStyles.pink : ColorStyles.grey)
        }
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    AppointmentButton(action: { }, receptionTime: false)
}
