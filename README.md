# SecondaryTabView
A secondary tab navigation view that appears on the top of the screen. Smooth animations.

https://user-images.githubusercontent.com/2078653/203246335-a7328bee-8e87-41a0-8c99-6d3169c90a96.mov

## Motivation
The motivation comes from the deficiency of our existing navigation options. A tab bar provides primary navigation, and if a secondary tab is needed, it requires us to make custom views with stack navigations. This secondary tab navigation is a compact and customizable solution that leverages the power of `SwiftUI` to make ends meet.

## Usage
The screen recording is from the preview code in `SecondaryTabView.swift`. Refer to that for the full details.

1. Define an item type representing each tab's view model. A simple enum is usually sufficient.

```swift
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
```

2. In your container view, declare a selection state.

```swift
@State private var selection: Item = .first
```

3. Now you can use the secondary tab view as below. 

  a. You want to bind your selection state.
  b. Declare each tab's *content view* identify each with `.tabItem(for: <Instance of Item>)`. In the example below the content is a simple `Text` view, but it can be anything you want.
  c. Provide a label for each tab. You may customize the appearance based on the selection state.
  d. There are customizations for the selection underline and view modifier.
```swift
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
```
