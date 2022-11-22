//
//  SecondaryTabView.swift
//  SecondaryTabView
//
//  Created by Ben Lu on 12/26/21.
//

import SwiftUI

/// A view model differentiating the tab view items, and provide necessary data to render the tab view labels.
public protocol SecondaryTabViewItem: Hashable {
}

/// A tab view that is designed to be used as secondary navigation below the primary navigation view to complement the bottom tab bar.
public struct SecondaryTabView<TabItem: SecondaryTabViewItem, Content: View, Label: View, Underline: View, BarViewModifier: ViewModifier>: View {
    @Namespace var namespace

    @State private var items: [TabItem]
    @State private var totalWidth: CGFloat = 0
    private let selectedItem: SecondaryTabViewSelection<TabItem>
    private let content: () -> Content
    private let label: (TabItem, Bool) -> Label
    private let underline: () -> Underline
    private let barViewModifier: BarViewModifier

    /// Initialize the secondary tab view.
    /// - Parameters:
    ///   - selection: A binding of the selected tab item.
    ///   - content: A view builder that renders the content view of each tab. Use `.tabItem(for:)` modifier to the content
    ///   views to identify which tab the content view belongs to.
    ///   - label: A view builder of tab bar labels. First argument `TabItem` is the view model that is backing the label; second
    ///   argument `Bool` indicates whether the label is currently selected, as you might want to visually highlight it.
    ///   - underline: A view builder of the underline selected when a label is selected.
    ///   - barViewModifier: The view modfier of the bar view.You may specify the background color, or add a shadow by
    ///   providing a customer bar view modifier.
    public init(
        selection: Binding<TabItem>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping (TabItem, Bool) -> Label,
        @ViewBuilder underline: @escaping () -> Underline,
        barViewModifier: BarViewModifier
    ) {
        self.selectedItem = .init(selection: selection)
        self.content = content
        self.label = label
        self.underline = underline
        self.barViewModifier = barViewModifier

        self._items = .init(initialValue: .init())
    }

    var tabBar: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .local)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                let spacing: CGFloat = 10
                let padding: CGFloat = 16
                HStack(spacing: spacing) {
                    ForEach(self.items, id: \.self) { item in
                        SecondaryTabItemView(
                            item: item,
                            namespace: namespace.self,
                            tabBarItemView: label,
                            underline: underline,
                            // Evenly distribute extra space to each tab item to fill the width
                            sorroundingPadding: max(0, (frame.width - padding * 2 - spacing * CGFloat(items.count - 1) - totalWidth) / CGFloat(items.count) / 2)
                        )
                        .environmentObject(self.selectedItem)
                    }
                }
                .padding(.horizontal, padding)
            }
            .modifier(barViewModifier)
        }
        .onPreferenceChange(SecondaryTabViewWidthPreferenceKey.self) { totalWidth in
            self.totalWidth = totalWidth
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            tabBar
                .frame(height: 44)
                .zIndex(1)

            ZStack {
                content(
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(selectedItem)
            }
        }
        .onPreferenceChange(SecondaryTabViewPreferenceKey.self) { value in
            self.items = value
        }
    }
}

struct SecondaryTabItemView<TabItem: SecondaryTabViewItem, Content: View, Underline: View>: View {
    @EnvironmentObject var selectedItem: SecondaryTabViewSelection<TabItem>

    let item: TabItem
    let namespace: Namespace.ID
    let tabBarItemView: (TabItem, Bool) -> Content
    let underline: () -> Underline
    let sorroundingPadding: CGFloat

    init(
        item: TabItem,
        namespace: Namespace.ID,
        @ViewBuilder tabBarItemView: @escaping (TabItem, Bool) -> Content,
        @ViewBuilder underline: @escaping () -> Underline,
        sorroundingPadding: CGFloat
    ) {
        self.item = item
        self.namespace = namespace
        self.tabBarItemView = tabBarItemView
        self.underline = underline
        self.sorroundingPadding = sorroundingPadding
    }

    var body: some View {
        Button {
            self.selectedItem.selection = item
            self.selectedItem.objectWillChange.send()
        } label: {
            VStack {
                Spacer()

                tabBarItemView(
                    item,
                    selectedItem.selection == item
                )
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: SecondaryTabViewWidthPreferenceKey.self,
                            value: proxy.size.width
                        )
                    }
                )
                .padding([.leading, .trailing], sorroundingPadding)

                if selectedItem.selection == item {
                    underline(
                    )
                    .frame(height: 2)
                    .matchedGeometryEffect(
                        id: "underline",
                        in: namespace,
                        properties: .frame
                    )
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(
                .spring(),
                value: selectedItem.selection
            )
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG

struct SecondaryTabView_Previews: PreviewProvider {
    struct ShadowModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
            .background(
                Color.white.shadow(
                    color: Color.black.opacity(0.07),
                    radius: 4,
                    x: 0,
                    y: 2
                )
            )
        }
    }

    struct ContentView: View {
        private enum Item: Int, SecondaryTabViewItem {
            case first = 0
            case second
            case third
            case fourth

            var text: String {
                switch self {
                case .first: return "First"
                case .second: return "Second"
                case .third: return "Third"
                case .fourth: return "Fourth name too long"
                }
            }
        }

        @State private var selection: Item = .first

        var body: some View {
            NavigationView {
                SecondaryTabView(
                    selection: $selection,
                    content: {
                        Text(verbatim: "First")
                            .tabItem(for: Item.first)

                        Text(verbatim: "Second")
                            .tabItem(for: Item.second)

                        Text(verbatim: "Third")
                            .tabItem(for: Item.third)

                        Text(verbatim: "Fourth name too long")
                            .tabItem(for: Item.fourth)
                    },
                    label: { item, isSelected in
                        Text(
                            item.text
                        )
                        .foregroundColor(isSelected ? Color.orange : Color.primary)
                    },
                    underline: {
                        Color.orange
                        .frame(height: 2)
                    },
                    barViewModifier: ShadowModifier()
                )
                .navigationTitle("Top navigation")
            }
        }
    }

    static var previews: some View {
        ContentView()
    }
}

#endif
