//
//  SecondaryTabViewWidthPreferenceKey.swift
//  SecondaryTabView
//
//  Created by Ben Lu on 12/26/21.
//

import SwiftUI

/// A preference key to record to total width of tab bar items.
public struct SecondaryTabViewWidthPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat {
        return 0
    }

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
       value += nextValue()
    }
}
