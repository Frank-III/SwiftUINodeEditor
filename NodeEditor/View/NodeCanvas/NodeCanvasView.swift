//
//  NodeCanvasView.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/17/22.
//

import SwiftUI
import UIKit

struct NodeCanvasView: View {
    
    @EnvironmentObject var nodeCanvasData : NodeCanvasData
    
    var body: some View {
        ZStack {
            
            ScrollView([.horizontal, .vertical]) {
                ZStack {

                    Color.clear.frame(width: nodeCanvasData.canvasSize.width, height: nodeCanvasData.canvasSize.height, alignment: .center)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    
                                })
                                .onEnded({ value in
                                    
                                })
                        )
                    
                    ForEach(nodeCanvasData.nodes) { nodeData in
                        NodeView(nodeData: nodeData)
                    }
                    
                    Canvas(opaque: false, colorMode: .extendedLinear, rendersAsynchronously: true) { context, size in
                        
                        // stable lines
                        let stablePath = UIBezierPath()
                        nodeCanvasData.nodes.flatMap({ nodeData in
                            nodeData.outPorts.flatMap { nodePortData in
                                nodePortData.connections
                            }
                        })
                        .forEach { nodePortConnectionData in
                            let startPos = nodePortConnectionData.startPos
                            let endPos = nodePortConnectionData.endPos
                            let distance = abs(startPos.x - endPos.x)
                            let controlPoint1 = startPos + CGPoint.init(x: distance, y: 0)
                            let controlPoint2 = endPos - CGPoint.init(x: distance, y: 0)
                            stablePath.move(to: startPos)
                            stablePath.addCurve(to: endPos,
                                          controlPoint1: controlPoint1,
                                          controlPoint2: controlPoint2)
                        }
                        context.stroke(.init(stablePath.cgPath), with: .color(.green), lineWidth: 4)
                        
                        // pending lines
                        nodeCanvasData.pendingConnections
                        .forEach { nodePortConnectionData in
                            let unstablePath = UIBezierPath()
                            let startPos = nodePortConnectionData.startPos
                            let endPos = nodePortConnectionData.endPos
                            let distance = abs(startPos.x - endPos.x)
                            let controlPoint1 = startPos + CGPoint.init(x: distance, y: 0)
                            let controlPoint2 = endPos - CGPoint.init(x: distance, y: 0)
                            unstablePath.move(to: startPos)
                            unstablePath.addCurve(to: endPos,
                                          controlPoint1: controlPoint1,
                                          controlPoint2: controlPoint2)
                            var colors : [Color] = []
                            if nodePortConnectionData.getPendingPortDirection == .output {
                                colors.append(Color.yellow)
                                colors.append(Color.green)
                            } else if nodePortConnectionData.getPendingPortDirection == .input {
                                colors.append(Color.green)
                                colors.append(Color.yellow)
                            } else {
                                colors.append(Color.green)
                            }
                            context.stroke(.init(unstablePath.cgPath), with: .linearGradient(.init(colors: colors), startPoint: startPos, endPoint: endPos), lineWidth: 4)
                                                   
                        }
                        
                    }
                    .allowsHitTesting(false)
                    
                }
                .coordinateSpace(name: "canvas")
                .clipped()
                .background(GeometryReader(content: { proxy in
                    VStack(alignment: .leading) {
                        Text("Canvas Size \(proxy.size.width) × \(proxy.size.height)")
                            .font(.subheadline.monospaced())
                            .foregroundColor(.init(uiColor: UIColor.secondaryLabel))
                        Text("Node Count \(nodeCanvasData.nodes.count)")
                            .font(.subheadline.monospaced())
                            .foregroundColor(.init(uiColor: UIColor.secondaryLabel))
                        Text("Pending Connection Count \(nodeCanvasData.pendingConnections.count)")
                            .font(.subheadline.monospaced())
                            .foregroundColor(.init(uiColor: UIColor.secondaryLabel))
                    }
                    .padding()
                }))
            }
            
//            NodeCanvasMinimapView()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct NodeCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        NodeCanvasView()
    }
}
