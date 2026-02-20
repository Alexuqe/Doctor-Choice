import SwiftUI

struct IndicatorView<Indicator: View>: View {
    let indicatorView: (CGSize) -> Indicator
    let excessTabWidth: CGFloat
    let minX: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            indicatorView(size)
            .frame(
                width: size.width,
                height: size.height,
                alignment: excessTabWidth < 0 ? .trailing : .leading
            )
            .offset(x: minX)
        }
    }
}

