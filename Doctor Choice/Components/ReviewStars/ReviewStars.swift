import SwiftUI

struct ReviewStars: View {
    private let rating: Int

    init(rating: Int) {
        self.rating = rating
    }

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundStyle(star <= rating ? ColorStyles.pink : ColorStyles.grey)
            }
        }
    }
}
