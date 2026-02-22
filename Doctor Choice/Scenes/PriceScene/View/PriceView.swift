import SwiftUI

struct PriceView: View {
    private let user: User

    init(user: User) {
        self.user = user
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PriceLabel(
                title: "Text chat",
                serviceDetail: "30 min",
                price: user.textChatPrice
            )

            PriceLabel(
                title: "Video chat",
                serviceDetail: "30 min",
                price: user.videoChatPrice
            )

            if let hospitalPrice = user.hospitalPrice {
                PriceLabel(
                    title: "Прием в клинике",
                    serviceDetail: "в клинике",
                    price: hospitalPrice
                )
            }

            Spacer()

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .navigationTitle("Стоимость услуг")
    }
}

struct PriceLabel: View {
    private let title: String
    private let serviceDetail: String
    private let price: Int

    init(title: String, serviceDetail: String, price: Int) {
        self.title = title
        self.serviceDetail = serviceDetail
        self.price = price
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
            .font(FontStyle.h4.font)
            .foregroundStyle(ColorStyles.black)
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text(serviceDetail)
                .font(FontStyle.sub1.font)
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(price) ₽")
                .font(FontStyle.h4.font)
            }
            .foregroundStyle(ColorStyles.black)
            .bordered()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PriceLabel(title: "View", serviceDetail: "30 min", price: 300)
}
