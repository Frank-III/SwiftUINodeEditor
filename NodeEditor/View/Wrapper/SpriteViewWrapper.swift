//
//  SpriteViewWrapper.swift
//  ScriptNode
//
//  Created by fincher on 4/23/22.
//

import Foundation
import SpriteKit
import SwiftUI

#if os(iOS)
typealias ViewRepresentableType = UIViewRepresentable
#elseif os(macOS)
typealias ViewRepresentableType = NSViewRepresentable
#endif

struct SpriteViewWrapper: ViewRepresentableType {
    
    @Binding var scene: SKScene
    @Binding var paused: Bool

    // MARK: - iOS Specific
    #if os(iOS)
    func makeUIView(context: Context) -> SKView {
        createView()
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        updateView(uiView)
    }
    #endif

    // MARK: - macOS Specific
    #if os(macOS)
    func makeNSView(context: Context) -> SKView {
        createView()
    }

    func updateNSView(_ nsView: SKView, context: Context) {
        updateView(nsView)
    }
    #endif

    // MARK: - Shared
    private func createView() -> SKView {
        let view = SKView()
        view.isAsynchronous = true
        view.preferredFramesPerSecond = 30
        view.showsFPS = true
        view.showsDrawCount = true
        view.showsPhysics = true
        view.showsFields = true
        #if os(iOS)
        view.showsLargeContentViewer = true
        #endif
        view.delegate = RenderManager.shared
        return view
    }

    private func updateView(_ view: SKView) {
        view.presentScene(nil)
        view.presentScene(scene)
        view.isPaused = paused
    }
}
