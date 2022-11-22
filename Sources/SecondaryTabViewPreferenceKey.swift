//
//  SecondaryTabViewPreferenceKey.swift
//  SecondaryTabView
//
//  Created by Ben Lu on 12/26/21.
//

import SwiftUI

public struct SecondaryTabViewPreferenceKey<TabItem: SecondaryTabViewItem>: PreferenceKey {
    public static var defaultValue: [TabItem] {
        return .init()
    }

    public static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value.append(contentsOf: nextValue())
    }
}
