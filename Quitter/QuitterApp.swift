//
//  QuitterApp.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-10-31.
//

import SwiftUI

@main
struct QuitterApp: App {
    @State var searchText: String = ""

    var body: some Scene {
        MenuBarExtra("Quitter", systemImage: "xmark.seal.fill") {
            VStack {
                TextField("Filter by name...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .padding([.horizontal, .top])

                ScrollView(.vertical, showsIndicators: false) {
                    ProcessesView(searchText: $searchText)
                }
            }

            .frame(height: 420)
        }
        .menuBarExtraStyle(.window)
    }
}
