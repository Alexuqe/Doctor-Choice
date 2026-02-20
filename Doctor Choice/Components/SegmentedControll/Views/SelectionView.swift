import SwiftUI

struct SelectionView: View {
    @Binding var selectedTab: Selection
    var tab: Selection

    var body: some View {
        HStack(alignment: .center) {
            Text(tab.title)

            if let image = tab.image {
                Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 5, height: 10)
            }
        }
        .foregroundStyle(selectedTab == tab ? .white : .gray)
        .font(selectedTab == tab ? FontStyle.sub1.font : FontStyle.sub2.font)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(maxHeight: .infinity)
        .contentShape(.rect)
        .animation(.easeInOut, value: selectedTab)
    }
}
