//
//  TabBarView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import SwiftUI

struct TabItemData {
    let image: String
    let title: String
}

enum Tab: Int, CaseIterable {
    case home
    case library
    case profile
    
    var tabItem: TabItemData {
        switch self {
        case .home:
            TabItemData(image: "play.house.fill",
                        title: String(localized: "TabItemHome"))
        case .library:
            TabItemData(image: "books.vertical.fill",
                        title: String(localized: "TabItemLibrary"))
        case .profile:
            TabItemData(image: "person.crop.circle.fill",
                        title: String(localized: "TabItemProfile"))
        }
    }
    
    var route: Route {
        switch self {
        case .home:
                .home
        case .library:
                .library
        case .profile:
                .profile
        }
    }
}

struct TabBarView: View {
    
    var tabs: [Tab] {
        Tab.allCases
    }
    @State var selectedIndex: Int = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    var body: some View {
        TabView(selection: $selectedIndex,
                content:  {
            ForEach(tabs.indices, id: \.self) { index in
                NavigationStack {
                    tabs[index].route.view
                }
                .tabItem {
                    Text(tabs[index].tabItem.title)
                    Image(systemName: tabs[index].tabItem.image)
                        .renderingMode(.template)
                }
                .tag(index)
            }
        })
        .tint(Color("GreenColor"))
        
    }
}

#Preview {
    TabBarView()
}
