import SwiftUI

struct PriceButton: View {
    private let price: Int
    private let action: () -> Void

    init(price: Int, action: @escaping () -> Void) {
        self.price = price
        self.action = action
    }

    var body: some View {
        HStack() {
            Text("Стоимость услуг")
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("от \(price) ₽")
        }
        .font(FontStyle.h4.font)
        .foregroundStyle(ColorStyles.black)
        .bordered()
        .contentShape(.rect)
        .onTapGesture {
            action()
        }
    }
}


struct Border: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .fill(ColorStyles.grey)
        }
    }
}

extension View {
    func bordered() -> some View {
        modifier(Border())
    }
}
