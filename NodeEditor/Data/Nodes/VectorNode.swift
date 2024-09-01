//
//  VectorNode.swift
//  ScriptNode
//
//  Created by fincher on 4/23/22.
//

import Foundation
import SwiftUI
import SpriteKit

class VectorNode : NodeData {
    
    override class func getDefaultCategory() -> String {
        "Variable"
    }
    
    class override func getDefaultTitle() -> String {
        "Vector 🏹"
    }
    
    override class func getDefaultUsage() -> String {
        "Vector provides a (x,y) value for the direction and length"
    }
    
    class override func getDefaultDataOutPorts() -> [NodeDataPortData] {
        return [
            CGVectorNodeDataPort(portID: 0, name: "Result", direction: .output)
        ]
    }
    
    static var scaler = 200
    static var joystickSize = 120.0
    
    override class func getDefaultCustomRendering(node: NodeData) -> AnyView? {
        AnyView(
            VStack(alignment: .leading, spacing: 2) {
                if let port = node.outDataPorts[safe: 0],
                   let portValue = port.value as? CGVector {
                    Canvas(opaque: false, colorMode: .extendedLinear, rendersAsynchronously: true, renderer: { context, size in
                        let axis = Path { path in
                            path.move(to: CGPoint(x: 0, y: size.height / 2.0))
                            path.addLine(to: CGPoint(x: size.width, y: size.height / 2.0))
                            path.move(to: CGPoint(x: size.width / 2.0, y: 0))
                            path.addLine(to: CGPoint(x: size.width / 2.0, y: size.height))
                        }
                        context.stroke(axis, with: .color(Color.platformQuaternaryLabel), lineWidth: 2)
                        
                        let arrow = Path { path in
                            path.move(to: CGPoint(x: size.width / 2.0, y: size.height / 2.0))
                            path.addLine(to: CGPoint(x: portValue.dx / Double(scaler) * size.width + size.width / 2.0,
                                                     y: -portValue.dy / Double(scaler) * size.height + size.height / 2.0))
                        }
                        context.stroke(arrow, with: .color(Color.platformQuaternaryLabel), lineWidth: 2)
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.platformSecondaryLabel, lineWidth: 4)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                port.value = CGVector(dx: (value.location.x / joystickSize - 0.5) * Double(scaler),
                                                      dy: -(value.location.y / joystickSize - 0.5) * Double(scaler))
                            })
                    )
                    .frame(width: joystickSize, height: joystickSize, alignment: .center)
                    
                    HStack {
                        Text("X")
                        TextField("X", value: Binding(get: {
                            portValue.dx
                        }, set: { newValue in
                            port.value = CGVector(dx: newValue, dy: portValue.dy)
                        }), formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                    }
                    .font(.caption.monospaced())
                    
                    HStack {
                        Text("Y")
                        TextField("Y", value: Binding(get: {
                            portValue.dy
                        }, set: { newValue in
                            port.value = CGVector(dx: portValue.dx, dy: newValue)
                        }), formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                    }
                    .font(.caption.monospaced())
                }
            }.frame(width: joystickSize, alignment: .center)
        )
    }
}
