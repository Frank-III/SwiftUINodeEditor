//
//  VectorNode.swift
//  ScriptNode
//
//  Created by fincher on 4/23/22.
//

import Foundation
import SwiftUI

class VectorNode : NodeData {
    
    override class func getDefaultCategory() -> String {
        "Variable"
    }
    
    class override func getDefaultTitle() -> String {
        "Vector"
    }
    
    class override func getDefaultDataOutPorts() -> [NodeDataPortData] {
        return [
            NodeDataPortData(portID: 0, direction: .output, name: "Result", defaultValue: CGVector.zero)
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
                            path.move(to: .init(x: 0, y: size.height / 2.0))
                            path.addLine(to: .init(x: size.width, y: size.height / 2.0))
                            path.move(to: .init(x: size.width / 2.0, y: 0))
                            path.addLine(to: .init(x: size.width / 2.0, y: size.height))
                        }
                        context.stroke(axis, with: .color(.init(uiColor: UIColor.quaternaryLabel)), lineWidth: 2)
                        
                        let arrow = Path { path in
                            path.move(to: .init(x: size.width / 2.0, y: size.height / 2.0))
                            path.addLine(to: .init(x: portValue.dx / Double(scaler) * size.width + size.width / 2.0,
                                                   y: -portValue.dy / Double(scaler) * size.height + size.height / 2.0))
                        }
                        context.stroke(arrow, with: .color(.init(uiColor: UIColor.quaternaryLabel)), lineWidth: 2)
                        
                        context.draw(.init(systemName: "circle"), in: .init(
                            origin:
                                .init(x: portValue.dx / Double(scaler) * size.width - 5.0 + size.width / 2.0,
                                      y: -portValue.dy / Double(scaler) * size.height - 5.0 + size.height / 2.0),
                            size: .init(width: 10, height: 10)))
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.init(uiColor: UIColor.secondaryLabel), lineWidth: 4)
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
                        
//                        Text("\(-scaler/2)")
//
//                        Slider(value: Binding<Double>.init(get: {
//                            portValue.dx
//                        }, set: { newX in
//                            port.value = CGVector(dx: newX, dy: portValue.dy)
//                        }), in: -Double(scaler)/2.0...Double(scaler)/2.0) {
//                            Text("X")
//                        } onEditingChanged: { editing in
//
//                        }
//                        Text("\(scaler/2)")
                        
                        TextField("X", text: .init(get: {
                            "\(portValue.dx)"
                        }, set: { newValue in
                            port.value = CGVector(dx: Double(newValue) ?? 0.0, dy: portValue.dy)
                        }), onEditingChanged: { changed in
                            
                        }).textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                    .font(.caption.monospaced())
                    
                    HStack {
                        Text("Y")
                        
//                        Text("\(-scaler/2)")
//                        Slider(value: Binding<Double>.init(get: {
//                            portValue.dy
//                        }, set: { newY in
//                            port.value = CGVector(dx: portValue.dx, dy: newY)
//                        }), in: -Double(scaler)/2.0...Double(scaler)/2.0) {
//                            Text("Y")
//                        } onEditingChanged: { editing in
//
//                        }
//                        Text("\((scaler/2))")
                        
                        TextField("Y", text: .init(get: {
                            "\(portValue.dy)"
                        }, set: { newValue in
                            port.value = CGVector(dx: portValue.dx, dy: Double(newValue) ?? 0.0)
                        }), onEditingChanged: { changed in
                            
                        }).textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                    .font(.caption.monospaced())
                }
            }.frame(width: joystickSize, alignment: .center)
        )
    }
}


