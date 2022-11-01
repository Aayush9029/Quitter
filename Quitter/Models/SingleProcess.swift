//
//  SingleProcess.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-10-31.
//

import Foundation

struct SingleProcess: Identifiable {
    let id: String
    let cpu: String
    let path: String
    let name: String
    let type: ProcessType
}

enum ProcessType: Hashable {
    case prefPane
    case app
    case binary
}
