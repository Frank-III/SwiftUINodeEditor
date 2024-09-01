//
//  NodePortView.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/19/22.
//

import SwiftUI

struct NodePortView: View {
    
    @EnvironmentObject var nodeCanvasData : NodeCanvasData
    @ObservedObject var nodePortData : NodePortData
    @State var holdingKnot : Bool = false
    @State var holdingConnection : NodePortConnectionData? = nil
    
    var textView: some View {
        Text("\(nodePortData.name)")
            .lineLimit(1)
            .font(.footnote.monospaced())
    }
    
    var circleView: some View {
        nodePortData.icon()
            .foregroundColor(nodePortData.color())
            .scaleEffect(holdingKnot ? 1.5 : 1)
            .frame(width: 8, height: 8, alignment: .center)
            .padding(.all, 8)
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        nodePortData.canvasRect = proxy.frame(in: .named("canvas"))
                    }
                    .onChange(of: proxy.frame(in: .named("canvas"))) { portKnotFrame in
                        nodePortData.canvasRect = portKnotFrame
                    }
            })
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                    .onChanged({ value in
                        handleGestureChange(value)
                    })
                    .onEnded({ value in
                        handleGestureEnd(value)
                    })
            )
//            NO WORKING AT ALL
//            #if os(macOS)
//            .onHover { over in
//                if over {
//                    holdingKnot = true
//                } else {
//                    holdingKnot = false
//                }
//            }
//            #endif
    }
    
    func handleGestureChange(_ value: DragGesture.Value) {
        if !holdingKnot {
            holdingKnot = true
            
            if case .can = nodePortData.canConnect() {
                let newConnection = initiateConnection()
                nodeCanvasData.pendingConnections.append(newConnection)
                holdingConnection = newConnection
            } else if let existingConnection = nodePortData.connections.first {
                existingConnection.isolate()
                existingConnection.disconnect(portDirection: nodePortData.direction)
                nodeCanvasData.pendingConnections.append(existingConnection)
                holdingConnection = existingConnection
            }
        }
        
        if let holdingConnection = holdingConnection,
           let pendingDirection = holdingConnection.getPendingPortDirection {
            updatePendingConnection(pendingDirection, value)
        }
    }
    
    func handleGestureEnd(_ value: DragGesture.Value) {
        holdingKnot = false
        
        if let holdingConnection = holdingConnection,
           let pendingDirection = holdingConnection.getPendingPortDirection,
           let portToConnectTo = determinePortToConnectTo(pendingDirection, value) {
            portToConnectTo.connectTo(anotherPort: self.nodePortData)
        } else {
            holdingConnection?.disconnect()
        }
        
        nodeCanvasData.pendingConnections.removeAll { connection in
            connection == holdingConnection
        }
        holdingConnection = nil
    }
    
    func initiateConnection() -> NodePortConnectionData {
        if self.nodePortData.direction == .output {
            return NodePortConnectionData(startPort: self.nodePortData, endPort: nil)
        } else {
            return NodePortConnectionData(startPort: nil, endPort: self.nodePortData)
        }
    }
    
    func updatePendingConnection(_ pendingDirection: NodePortDirection, _ value: DragGesture.Value) {
        if pendingDirection == .input {
            holdingConnection?.endPosIfPortNull = value.location
        } else {
            holdingConnection?.startPosIfPortNull = value.location
        }
    }
    
    func determinePortToConnectTo(_ pendingDirection: NodePortDirection, _ value: DragGesture.Value) -> NodePortData? {
        nodeCanvasData.nodes.flatMap({ nodeData in
            pendingDirection == .input ? nodeData.inPorts : nodeData.outPorts
        }).filter({ nodePortData in
            if case .can = nodePortData.canConnectTo(anotherPort: self.nodePortData) {
                return true
            }
            return false
        }).filter({ nodePortData in
            nodePortData.canvasRect.contains(value.location)
        }).first
    }
    
    var body: some View {
        HStack {
            if self.nodePortData.direction == .input {
                circleView
                textView
            } else {
                textView
                circleView
            }
        }
        .padding(self.nodePortData.direction == .output ? .leading : .trailing, 8)
        .animation(.easeInOut, value: holdingKnot)
    }
}

struct NodePortView_Previews: PreviewProvider {
    static var previews: some View {
        NodePortView(nodePortData: NodeDataPortData(portID: 0, direction: .input))
    }
}
