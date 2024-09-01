//
//  NodeCanvasNavigationView.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/17/22.
//

import SwiftUI
import SpriteKit

struct NodeCanvasNavigationView: View {
    @ObservedObject var nodePageData: NodePageData = PageManager.shared.nodePageData
    @EnvironmentObject var environment: Environment
    @State var showSettings: Bool = false
    var indicating: Binding<Bool> = .init(get: {
        EnvironmentManager.shared.environment.toggleDocPanel || EnvironmentManager.shared.environment.toggleLivePanel
    }, set: { _, _ in })

    var body: some View {
        Group {
            #if os(iOS)
            iosView
            #elseif os(macOS)
            macView
            #endif
        }
        .environmentObject(nodePageData)
        .environmentObject(nodePageData.nodeCanvasData)
    }

    #if os(iOS)
    private var iosView: some View {
        ZStack {
            HStack(alignment: .center, spacing: 8) {
                if environment.toggleDocPanel {
                    NodeCanvasTitleIndicatorView(title: "Documentation", indicating: indicating, childView: NodeCanvasDocView())
                        .layoutPriority(1)
                }
                NodeCanvasTitleIndicatorView(title: "Editor", indicating: indicating, childView: NodeCanvasView())
                    .layoutPriority(1)
                if environment.toggleLivePanel {
                    NodeCanvasTitleIndicatorView(title: "Live", indicating: indicating, childView: NodeCanvasLiveView())
                        .layoutPriority(0)
                }
            }
            .padding(.all, 8)
            NodeCanvasToolbarView()
        }
        .animation(.easeInOut, value: environment.toggleDocPanel)
        .animation(.easeInOut, value: environment.toggleLivePanel)
        .navigationViewStyle(.stack)
    }
    #endif

    #if os(macOS)
    private var macView: some View {
        NavigationStack {
            ZStack {
                HStack(alignment: .center, spacing: 8) {
                    if environment.toggleDocPanel {
                        NodeCanvasTitleIndicatorView(title: "Documentation", indicating: indicating, childView: NodeCanvasDocView())
                            .layoutPriority(1)
                    }
                    NodeCanvasTitleIndicatorView(title: "Editor", indicating: indicating, childView: NodeCanvasView())
                        .layoutPriority(1)
                    if environment.toggleLivePanel {
                        NodeCanvasTitleIndicatorView(title: "Live", indicating: indicating, childView: NodeCanvasLiveView())
                            .layoutPriority(0)
                    }
                }
                .padding(.all, 8)
//               NodeCanvasToolbarView()
            }
            .animation(.easeInOut, value: environment.toggleDocPanel)
            .animation(.easeInOut, value: environment.toggleLivePanel)
            .navigationViewStyle(.columns)
        }
        .toolbar {
            ToolbarItem{
                ToggleButtonView(icon: .init(systemName:"rectangle.lefthalf.inset.filled"), state: $environment.toggleDocPanel)
            }
            ToolbarItem(placement: .automatic) {
                ToggleButtonView(icon: .init(systemName:"rectangle.righthalf.inset.filled"), state: $environment.toggleLivePanel)
            }
            ToolbarItem() {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(.all, 8)
                }
                .popover(isPresented: $showSettings) {
                    MoreNavigationView()
                }
            }
        }
//        NavigationView {
//            List {
//                if environment.toggleDocPanel {
//                    NavigationLink(destination: NodeCanvasDocView()) {
//                        Label("Documentation", systemImage: "doc.text")
//                    }
//                }
//                NavigationLink(destination: NodeCanvasView()) {
//                    Label("Editor", systemImage: "square.split.2x2")
//                }
//                if environment.toggleLivePanel {
//                    NavigationLink(destination: NodeCanvasLiveView()) {
//                        Label("Live", systemImage: "livephoto")
//                    }
//                }
//            }
//            .listStyle(SidebarListStyle())
//            NodeCanvasView()
//        }
//        .frame(minWidth: 800, minHeight: 600)
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                NodeCanvasToolbarView()
//            }
//        }
    }
    #endif
}

struct NodeCanvasNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCanvasNavigationView()
    }
}
