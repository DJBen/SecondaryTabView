//
//  SecondaryTabViewModifier.swift
//  SecondaryTabView
//
//  Created by Ben Lu on 12/26/21.
//

import SwiftUI

struct SecondaryTabViewModifier<TabItem: SecondaryTabViewItem>: ViewModifier {
    @EnvironmentObject private var selectionObject: SecondaryTabViewSelection<TabItem>

    public let item: TabItem

    public func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: SecondaryTabViewPreferenceKey.self, value: [self.item])
    }
}

extension View {
    /// Declare the tab item as a tab in the secondary tab view.
    /// It is recommended to put this as the last modifier or it might not be recognized.
    /// - Returns: A view with modifier added on top.
    public func tabItem<TabItem: SecondaryTabViewItem>(for item: TabItem) -> some View {
        return self.modifier(SecondaryTabViewModifier(item: item))
    }
}
