//
//  ListNode.swift
//  ScriptNode
//
//  Created by Jiangda on 8/24/24.
//

import Foundation
import SpriteKit
import SwiftUI

//struct ListNodeItem: Codable {
//  var id: String
//  var name: String
//}
//
//class ListNode: NodeData {
//  override class func getDefaultCategory() -> String {
//    "Selector"
//  }
//
//  class override func getDefaultTitle() -> String {
//    "Just a List"
//  }
//
//  @Published var items = [
//    ListNodeItem(id: "1", name: "Item 1"),
//    ListNodeItem(id: "2", name: "Item 2"),
//    ListNodeItem(id: "3", name: "Item 3"),
//  ]
//
//    override class func getDefaultDataInPorts() -> [NodeDataPortData] {
//        return [
//            CGFloatNodeDataPort(portID: 0, name: "Value", direction: .input)
//        ]
//    }
//    
//    override class func getDefaultDataOutPorts() -> [NodeDataPortData] {
//        return [
//            CGFloatNodeDataPort(portID: 0, name: "Result", direction: .output)
//        ]
//    }
//
//  override class func getDefaultCustomRendering(node: NodeData) -> AnyView? {
//    guard let node = node as? ListNode else {
//      return nil
//    }
//
//    return AnyView(
//        HStack {
//            Text("List")
//            List(node.items, id: \.id) { item in
//                TextField("Item", text: .constant(item.name))
//            }
//        }
//        .frame(minWidth: 100, maxWidth: 180, alignment: .center)
//    )
//  }
//}
