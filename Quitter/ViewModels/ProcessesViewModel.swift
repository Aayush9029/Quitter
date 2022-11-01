//
//  ProcessesViewModel.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-10-31.
//

import SwiftUI

class ProcessViewModel: ObservableObject {
    @Published var processes: [SingleProcess] = []

    init() {
        fetchProcesses()
    }

    func fetchProcesses() {
        let rawProcesses = shell("ps -eo pid,pcpu,comm | sort -nrk 2,3").split(separator: "\n")
        for process in rawProcesses {
            addToProcesses(process)
        }
    }

    private func addToProcesses(_ line: Substring) {
        do {
            let line = String(line)
            let matches = /(\d+)\s+(\d+[.|,]\d+)\s+(.*)/
            if let result = try matches.wholeMatch(in: line) {
                let id = String(result.1)
                let cpu = String(result.2)
                let path = String(result.3)
                let processName = String(path.split(separator: "/").last ?? "Unknown")
                let type: ProcessType = path.contains(".prefPane") ? .prefPane : (path.contains(".app") ? .app : .binary)
                let process = SingleProcess(
                    id: id,
                    cpu: cpu,
                    path: path,
                    name: processName,
                    type: type
                )
                processes.append(process)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    static func getFileIcon(process: SingleProcess) -> String {
        switch process.type {
        case .prefPane:
            return process.path.replacing(/(.+\.prefPane)(.+)/, with: "$1")
        case .app:
            return process.path.replacing(/(.+\.app)(.+)/, with: "$1")
        case .binary:
            return "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ExecutableBinaryIcon.icns"
        }
    }

    private func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }
}
