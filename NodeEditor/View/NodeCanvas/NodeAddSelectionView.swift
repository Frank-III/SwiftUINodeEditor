//
//  NodeAddView.swift
//  ScriptNode
//
//  Created by fincher on 4/21/22.
//

import SwiftUI

struct NodeCanvasAddNodePointView : View {
    @Binding var popoverPosition : CGPoint
    @Binding var showPopover : Bool
    
    var body: some View {
        Color.clear.frame(width: 1, height: 1, alignment: .center)
            .popover(isPresented: $showPopover, attachmentAnchor: .point(.zero)) {
                NodeAddSelectionView(showPopover: $showPopover, nodePosition: $popoverPosition)
            }
    }
}

struct NodeAddSelectionView: View {
    @EnvironmentObject var nodeCanvasData : NodeCanvasData
    @Binding var showPopover : Bool
    @Binding var nodePosition : CGPoint
    @State private var nodeType = 0
    
    var nodeTypeList : [NodeData.Type] {
        subclasses(of: NodeData.self)
    }
    
    var nodeList : [NodeData] {
        nodeTypeList.enumerated().map { (index, nodeType) in
            nodeType.init(nodeID: index)
        }
    }

    
    var body: some View {
        NavigationView {
            List{
                ForEach(nodeList) { nodeData in
                    Button {
                        showPopover = false
                        nodeCanvasData.addNode(newNodeType: type(of: nodeData), position: nodePosition)
                    } label: {
                        HStack {
                            Text("\(nodeData.title)")
                                .font(.body.monospaced())
                            Spacer()
                            NodeView(demoMode: true, nodeData: nodeData)
                                .padding()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Node Type", selection: $nodeType) {
                        Text("Control Nodes").tag(0)
                        Text("Data Nodes").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Node")
        }
        .frame(minWidth: 300, idealWidth: 380, maxWidth: nil,
               minHeight: 360, idealHeight: 540, maxHeight: nil,
               alignment: .top)
    }
}
