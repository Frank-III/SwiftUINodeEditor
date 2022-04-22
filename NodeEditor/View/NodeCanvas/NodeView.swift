//
//  NodeView.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/18/22.
//

import SwiftUI
import UIKit

struct NodeView: View, Identifiable {
    var id: UUID = UUID()
    @State var demoMode = false
    @State var holding = false
    @ObservedObject var nodeData : NodeData
    @EnvironmentObject var nodeCanvasData : NodeCanvasData
    
    @State private var savedOffset: CGPoint = .zero
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(nodeData.title)")
                    .font(.title3.monospaced())
                
                if !nodeData.inControlPorts.isEmpty || !nodeData.outControlPorts.isEmpty {
                    Text("CONTROL FLOW")
                        .foregroundColor(Color.blue.opacity(0.8))
                        .font(.caption.bold().monospaced())
                }
                HStack(alignment: .top) {
                    if !nodeData.inControlPorts.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(nodeData.inControlPorts) { nodePortData in
                                NodePortView(nodePortData: nodePortData)
                            }
                        }
                        .padding(.all, 4)
                        .layoutPriority(1)
                    }
                    
                    
                    if !nodeData.outControlPorts.isEmpty {
                        VStack(alignment: .trailing) {
                            ForEach(nodeData.outControlPorts) { nodePortData in
                                NodePortView(nodePortData: nodePortData)
                            }
                        }
                        .padding(.all, 4)
                        .layoutPriority(1)
                    }
                }
                .background(Color.blue.opacity(0.3))
                .mask(RoundedRectangle(cornerRadius: 6))
                
                if !nodeData.inDataPorts.isEmpty || !nodeData.outDataPorts.isEmpty {
                    Text("DATA FLOW")
                        .foregroundColor(Color.green.opacity(0.8))
                        .font(.caption.bold().monospaced())
                }
                HStack(alignment: .top) {
                    if !nodeData.inDataPorts.isEmpty {
                        VStack(alignment: .leading) {
                            ForEach(nodeData.inDataPorts) { nodePortData in
                                NodePortView(nodePortData: nodePortData)
                            }
                        }
                        .padding(.all, 4)
                        .layoutPriority(1)
                    }
                    
                    
                    if !nodeData.outDataPorts.isEmpty {
                        VStack(alignment: .trailing) {
                            ForEach(nodeData.outDataPorts) { nodePortData in
                                NodePortView(nodePortData: nodePortData)
                            }
                        }
                        .padding(.all, 4)
                        .layoutPriority(1)
                    }
                }
                .background(Color.green.opacity(0.3))
                .mask(RoundedRectangle(cornerRadius: 6))
                
                if let customView = type(of: nodeData).getDefaultCustomRendering(node: nodeData) {
                    Text("CUSTOM VIEW")
                        .foregroundColor(Color.orange.opacity(0.8))
                        .font(.caption.bold().monospaced())
                    customView
                }
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .conditionalModifier(!demoMode, transform: { view in
            view.contextMenu {
                Button {
                    
                } label: {
                    Label {
                        Text("Delete")
                    } icon: {
                        Image(systemName: "xmark")
                    }

                }

            }
        })
        .padding(.all, 8)
        .background(
            Color.clear.background(Material.ultraThin)
        )
        .mask {
            RoundedRectangle(cornerRadius: 8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.orange, lineWidth: holding ? 4 : 0)
        )
        .shadow(color: .black.opacity(holding ? 0.1 : 0.15), radius: holding ? 24 : 12, x: 0, y: 0)
        .scaleEffect(1 + (holding ? 0.1 : 0.0))
        .allowsHitTesting(!demoMode)
        .disabled(demoMode)
        .conditionalModifier(!demoMode, transform: { view in
            view.position(nodeData.canvasPosition)
        })
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
            .onChanged { value in
                if !holding {
                    savedOffset = nodeData.canvasPosition
                    holding = true
                }
                nodeData.canvasPosition = savedOffset + value.translation.toPoint()
            }
            .onEnded { value in
                nodeData.canvasPosition = savedOffset + value.translation.toPoint()
                savedOffset = nodeData.canvasPosition
                holding = false
            }
        )
        .animation(.easeInOut, value: holding)
        .animation(.easeInOut, value: nodeData.canvasPosition)
    }
    
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(nodeData: NodeData(nodeID: 0, title: "Test"))
    }
}
