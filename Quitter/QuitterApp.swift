//
//  QuitterApp.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-10-31.
//

import SwiftUI

@main
struct QuitterApp: App {
    @StateObject var processesVM: ProcessViewModel = .init()

    var body: some Scene {
        MenuBarExtra("Quitter", systemImage: "xmark.seal.fill") {
            ScrollView {
                VStack {
                    ForEach(processesVM.processes) { process in

                        Button {
                            print("LIVE")
                        } label: {
                            HStack {
                                Image(systemName: process.type == .app ? "app.fill" : (process.type == .binary ? "shippingbox.fill" : "gearshape.2.fill"))
                                    .frame(width: 26)
                                Text(process.name)
                                Spacer()
                                Text(process.id)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                    .padding(4)
                                    .background(.red.opacity(0.125))
                                    .cornerRadius(16)
                            }
                            .padding(6)
                        }
                        .buttonStyle(.plain)
                        .background(.black.opacity(0.125))
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical)
            }
        }
        .menuBarExtraStyle(.window)
    }
}
