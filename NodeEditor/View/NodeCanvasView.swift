//
//  NodeCanvasView.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/17/22.
//

import SwiftUI
import UIKit

struct NodeCanvasView: View {
    
    @ObservedObject var nodeCanvasData : NodeCanvasData = NodeCanvasData().withTestConfig()
    
    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    
                    Color.clear.frame(width: nodeCanvasData.canvasSize.width, height: nodeCanvasData.canvasSize.height, alignment: .center)
                    
                    ForEach(nodeCanvasData.nodes) { nodeData in
                        NodeView(nodeData: nodeData)
                    }
                    
                    Canvas(opaque: false, colorMode: .extendedLinear, rendersAsynchronously: true) { context, size in
                        
                        let path = UIBezierPath()
                        
                        nodeCanvasData.nodes.forEach { nodeData in
                            nodeData.outPorts.forEach { nodePortData in
                                nodePortData.connections.forEach { nodePortConnectionData in
                                    if let startPort = nodePortConnectionData.startPort,
                                       let endPort = nodePortConnectionData.endPort {
                                        let distance = abs(startPort.canvasOffset.x - endPort.canvasOffset.x)
                                        let controlPoint1 = startPort.canvasOffset - CGPoint.init(x: distance, y: 0)
                                        let controlPoint2 = endPort.canvasOffset + CGPoint.init(x: distance, y: 0)
                                        
                                        path.move(to: startPort.canvasOffset)
                                        path.addCurve(to: endPort.canvasOffset,
                                                      controlPoint1: controlPoint1,
                                                      controlPoint2: controlPoint2)
                                    }
                                }
                            }
                        }
                        
                        context.stroke(.init(path.cgPath), with: .color(.green), lineWidth: 4)
                        
                        
                        
                    }
                    .allowsHitTesting(false)
                    
                }
                .coordinateSpace(name: "canvas")
                .clipped()
                .background(GeometryReader(content: { proxy in
                    ZStack {
                        Text("Canvas Size \(proxy.size.width) × \(proxy.size.height)")
                            .font(.subheadline.monospaced())
                            .foregroundColor(.init(uiColor: UIColor.secondaryLabel))
                    }
                    .padding()
                }))
            }
            NodeCanvasToolbarView()
            
        }.background(Color(UIColor.secondarySystemBackground))
    }
}

struct NodeCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCanvasView()
    }
}
