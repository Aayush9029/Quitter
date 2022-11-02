//
//  ProcessesView.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-11-01.
//

import SwiftUI

struct ProcessesView: View {
    @State private var applications: [NSRunningApplication] = [NSRunningApplication.current]
    @Binding var searchText: String

    var body: some View {
        VStack {
            ForEach(
                applications, id: \.self
            ) { app in
                SingleProcessView(app: app)
            }
        }.padding(8)
            .task(id: "QuitterAppsSync", priority: .high) {
                refreshApplications()
            }
            .onChange(of: searchText) { newValue in
                if applications.isEmpty {
                    refreshApplications()
                    applications = applications.filter {
                        $0.localizedName?.lowercased().contains(newValue.lowercased()) ?? true
                    }
                    return
                }
                if newValue.isEmpty {
                    refreshApplications()
                    return
                }
                applications = applications.filter {
                    $0.localizedName?.lowercased().contains(newValue.lowercased()) ?? true
                }
            }
    }

    func refreshApplications() {
        self.applications = NSWorkspace.shared.runningApplications
            .sorted(by: { app1, app2 in
                (app1.launchDate ?? Date()) < (app2.launchDate ?? Date())
            })
    }
}

struct ProcessesView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ProcessesView(searchText: .constant(""))
        }
        .frame(width: 420)
    }
}
