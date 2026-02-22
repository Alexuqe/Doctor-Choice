import SwiftUI

struct DoctorDetailLabel: View {
    private let image: String?
    private let systemImage: String?
    private let text: String?

    init(
        image: String? = nil,
        systemImage: String? = nil,
        text: String? = nil
    ) {
        self.image = image
        self.systemImage = systemImage
        self.text = text
    }

    var body: some View {
        HStack(spacing: 12) {
            defaultImage
            title
        }
    }
}

extension DoctorDetailLabel {
    var defaultImage: some View {
        createImage(name: image, systemName: systemImage)
        .resizable()
        .scaledToFit()
        .frame(width: 17, height: 17)
        .foregroundStyle(ColorStyles.darkGrey)

    }

    @ViewBuilder var title: some View {
        if let text {
            Text(text)
            .font(FontStyle.sub2.font)
            .foregroundStyle(ColorStyles.darkGrey)
            .lineLimit(1)
        }
    }

    private func createImage(name: String?, systemName: String?) -> Image {
        if let name {
            return Image(name)
        } else if let systemName {
            return Image(systemName: systemName)
        }

        return Image(systemName: "photo")
    }
}
