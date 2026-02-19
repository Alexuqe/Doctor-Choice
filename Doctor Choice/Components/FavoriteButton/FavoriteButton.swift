import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool

    var body: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 17)
            .foregroundStyle(isFavorite ? ColorStyles.pink : ColorStyles.silver)
            .symbolEffect(
                .bounce,
                options: .repeat(isFavorite ? 1 : 0),
                value: isFavorite
            )
            .onTapGesture {
                isFavorite.toggle()
            }
    }
}

#Preview {
    @Previewable @State var isFavorite = false

    FavoriteButton(isFavorite: $isFavorite)
}
