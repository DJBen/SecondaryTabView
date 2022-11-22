//
//  SecondaryTabViewSelection.swift
//  SecondaryTabView
//
//  Created by Ben Lu on 12/26/21.
//

import SwiftUI

public class SecondaryTabViewSelection<TabItem: SecondaryTabViewItem>: ObservableObject {
    @Binding public var selection: TabItem

    public init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}
