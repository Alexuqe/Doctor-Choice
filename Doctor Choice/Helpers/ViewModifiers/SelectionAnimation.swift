import SwiftUI

struct SelectionAnimation: ViewModifier {
    @Binding var selectedTab: Selection
    @Binding var excessTabWidth: CGFloat
    @Binding var minX: CGFloat

    var tabs: [Selection]
    var tab: Selection
    var containerWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .onTapGesture {
            if let index = tabs.firstIndex(of: tab),
                let activeIndex = tabs.firstIndex(of: selectedTab) {
                selectedTab = tab

                withAnimation(
                .snappy(duration: 0.25, extraBounce: 0),
                completionCriteria: .logicallyComplete) {
                excessTabWidth = containerWidth * CGFloat(index - activeIndex)
                    
              } completion: {

                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                minX = containerWidth * CGFloat(index)
                excessTabWidth = .zero
                }
              }
            }
          }
    }
}

