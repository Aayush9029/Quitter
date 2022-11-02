//
//  SingleProcessView.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-11-01.
//

import SwiftUI

struct SingleProcessView: View {
    @State private var hovered: Bool = false

    let app: NSRunningApplication

    var body: some View {
        Group {
            if !hovered {
                HStack {
                    Image(nsImage:
                        app.icon ?? NSImage(
                            symbolName: "doc.badge.gearshape.fill",
                            variableValue: 1.0
                        )!
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .shadow(color: .black.opacity(0.125), radius: 2, x: 2, y: 2)

                    Text(app.localizedName ?? "Unknown Application")

                    Spacer()

                    ProcessBadge(app: app)
                }
            } else {
                QuitView(app: app)
            }

        }.padding(6)
            .background(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(.gray.opacity(0.25), style: StrokeStyle(lineWidth: 1))
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                withAnimation {
                    hovered.toggle()
                }
            }
    }
}

struct SingleProcessView_Previews: PreviewProvider {
    static var previews: some View {
        SingleProcessView(app: NSRunningApplication.current)
            .padding()
            .frame(width: 420)
    }
}

extension SingleProcessView {
    @ViewBuilder
    private func QuitView(app: NSRunningApplication) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        print("Quiting \(app.localizedName!)")
                        app.forceTerminate()
                    } label: {
                        Label("Force Quit", systemImage: "xmark")
                            .pillButton(tint: .red)
                    }
                    .buttonStyle(.plain)

                    Button {
                        app.terminate()
                    } label: {
                        Label("Quit", systemImage: "xmark")
                            .pillButton(tint: .pink)
                    }
                    .buttonStyle(.plain)

                    Button {
                        if app.isHidden {
                            app.unhide()
                        } else {
                            app.hide()
                        }
                    } label: {
                        Label("Toggle", systemImage: app.isHidden ? "eye.slash" : "eye")
                            .pillButton(tint: .blue)
                    }
                    .buttonStyle(.plain)
                }
                HStack {
                    Button {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString(app.executableURL?.absoluteString.replacingOccurrences(of: "file:///", with: "") ?? "Error Executable Path", forType: .string)
                    } label: {
                        Label("Executable Path", systemImage: "clipboard")
                            .pillButton(tint: .orange)
                    }
                    .buttonStyle(.plain)

                    Button {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString(app.bundleIdentifier ?? "Error Copying Bundle Idenfier", forType: .string)
                    } label: {
                        Label("Bundle ID", systemImage: "clipboard")
                            .pillButton(tint: .teal)
                    }
                    .buttonStyle(.plain)

                    Button {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString("\(app.processIdentifier)", forType: .string)
                    } label: {
                        Label("PID", systemImage: "clipboard")
                            .pillButton(tint: .gray)
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack {
                Spacer()
                Text(app.bundleIdentifier ?? "unknown.identifier")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .symbolVariant(.fill)
        .symbolVariant(.circle)
    }

    @ViewBuilder
    private func ProcessBadge(app: NSRunningApplication) -> some View {
        Button {
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString("\(app.processIdentifier)", forType: .string)
        } label: {
            Text(String(app.processIdentifier))
                .foregroundColor(getColor(app.activationPolicy))
                .frame(width: 36)
                .pillButton(tint: getColor(app.activationPolicy))
        }
        .buttonStyle(.plain)
    }

    private func getColor(_ activationPolicy: NSApplication.ActivationPolicy) -> Color {
        if activationPolicy.rawValue == 0 {
            return .green
        } else if activationPolicy.rawValue == 1 {
            return .orange
        } else {
            return .gray
        }
    }
}
