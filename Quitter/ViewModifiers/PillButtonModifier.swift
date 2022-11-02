//
//  PillButtonModifier.swift
//  Quitter
//
//  Created by Aayush Pokharel on 2022-11-01.
//

import SwiftUI

struct PillButtonModifier: ViewModifier {
    @State private var hovered: Bool = false
    let tint: Color

    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(tint)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                Capsule(style: .continuous)
                    .stroke(tint)
                    .background(
                        Capsule(style: .continuous)
                            .fill(hovered ? tint.opacity(0.5) : Color.black.opacity(0.125))
                    )

                    .shadow(radius: 2)
            )
            .contentShape(Capsule(style: .continuous))

            .onHover { val in
                withAnimation(.easeInOut(duration: 0.125)) {
                    hovered = val
                }
            }
    }
}

extension View {
    func pillButton(tint: Color) -> ModifiedContent<Self, PillButtonModifier> {
        return modifier(PillButtonModifier(tint: tint))
    }
}
