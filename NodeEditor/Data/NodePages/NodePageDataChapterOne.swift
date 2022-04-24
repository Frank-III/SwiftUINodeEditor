//
//  NodePageDataChapterOne.swift
//  ScriptNode
//
//  Created by fincher on 4/24/22.
//

import Foundation
import SwiftUI
import SpriteKit

class NodePageDataProviderChapterOne : NodePageDataProvider
{
    func modifyCanvas(nodePageData : NodePageData) {
        nodePageData.nodeCanvasData.nodes = [
            GetTouchNode(nodeID: 0).withCanvasPosition(canvasPosition: .init(x: 120, y: 180)).withCanvas(canvasData: nodePageData.nodeCanvasData),
            BirdNode(nodeID: 1).withCanvasPosition(canvasPosition: .init(x: 80, y: 360)).withCanvas(canvasData: nodePageData.nodeCanvasData),
            ApplyImpulseNode(nodeID: 2).withCanvasPosition(canvasPosition: .init(x: 400, y: 200)).withCanvas(canvasData: nodePageData.nodeCanvasData),
            VectorNode(nodeID: 3).withCanvasPosition(canvasPosition: .init(x: 250, y: 480)).withCanvas(canvasData: nodePageData.nodeCanvasData)
        ]
    }
    
    func modifyDocView(nodePageData : NodePageData) {
        nodePageData.docView = AnyView(
            List {
                Section {
                    Text("👾 How to make games with script node editor")
                        .font(.headline.monospaced())
                    Text("🐦 Chapter 1 - Flappy Bird")
                        .font(.subheadline.monospaced())
                } header: {
                    VStack(alignment: .leading) {
                        Color.clear.frame(height: 40)
                        Text("TITLE")
                    }
                }

                
                Section {
                    Button {
                        self.cheat(nodePageData: nodePageData)
                    } label: {
                        Label("See final results 🥳", systemImage: "checkmark")
                            .font(.body.monospaced())
                    }
                } header: {
                    Text("")
                }

                
                Section {
                    Button {
                        nodePageData.switchTo(index: 0)
                    } label: {
                        Label("Previous Chapter", systemImage: "arrow.left")
                            .font(.body.monospaced())
                    }
                    
                    Button {
                    } label: {
                        Label("Next Chapter", systemImage: "arrow.right")
                            .font(.body.monospaced())
                    }
                } header: {
                    Text("CONTEXT")
                }


            }
        )
    }
    
    func modifyLiveScene(nodePageData : NodePageData) {
        let newScene = SKScene(fileNamed: "FlappyBird") ?? SKScene(size: .init(width: 375, height: 667))
        
        let birdAtlas = SKTextureAtlas(dictionary: ["downflap": UIImage(named: "yellowbird-downflap.png") as Any,
                                                    "midflap": UIImage(named: "yellowbird-midflap.png") as Any,
                                                    "upflap": UIImage(named: "yellowbird-upflap.png") as Any])
        
        let birdFlyFrames: [SKTexture] = [
            birdAtlas.textureNamed("downflap"),
            birdAtlas.textureNamed("midflap"),
            birdAtlas.textureNamed("upflap")
        ]
        birdFlyFrames.forEach { texture in
            texture.filteringMode = .nearest
        }
        nodePageData.bird = SKSpriteNode(texture: birdFlyFrames[0])
        nodePageData.bird.position = .zero
        nodePageData.bird.run(SKAction.repeatForever(
            SKAction.animate(with: birdFlyFrames,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                 withKey:"birdFlyAtlas")
        nodePageData.bird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 20))
        nodePageData.bird.physicsBody?.mass = 0.2
        
        
        let cityTexture = SKTexture(imageNamed: "background-day")
        cityTexture.filteringMode = .nearest
        let cityNode = SKSpriteNode(texture: cityTexture)
        cityNode.position = .init(x: 0, y: 50.5)
        cityNode.setScale(1.5)
        
        
        let groundTexture = SKTexture(imageNamed: "base")
        groundTexture.filteringMode = .nearest
        let groundNode = SKSpriteNode(texture: groundTexture)
        groundNode.setScale(1.5)
        groundNode.position = .init(x: 0, y: -280)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: groundNode.size)
        groundNode.physicsBody?.pinned = true
        groundNode.physicsBody?.affectedByGravity = false
        groundNode.physicsBody?.isDynamic = false
        groundNode.physicsBody?.allowsRotation = false
        
        
        
        newScene.addChild(cityNode)
        newScene.addChild(groundNode)
        newScene.addChild(nodePageData.bird)
        newScene.scaleMode = .aspectFill
        
        nodePageData.liveScene = newScene
    }
    
    func cheat(nodePageData : NodePageData) {
        destroy(nodePageData: nodePageData)
        modifyCanvas(nodePageData: nodePageData)
        modifyDocView(nodePageData: nodePageData)
        modifyLiveScene(nodePageData: nodePageData)
                
        if let port1 = nodePageData.nodeCanvasData.nodes[safe: 0]?.outControlPorts[safe: 0], let port2 = nodePageData.nodeCanvasData.nodes[safe: 2]?.inControlPorts[safe: 0] {
            port1.connectTo(anotherPort: port2)
        }
        if let port1 = nodePageData.nodeCanvasData.nodes[safe: 1]?.outDataPorts[safe: 0], let port2 = nodePageData.nodeCanvasData.nodes[safe: 2]?.inDataPorts[safe: 0] {
            port1.connectTo(anotherPort: port2)
        }
        if let port1 = nodePageData.nodeCanvasData.nodes[safe: 3]?.outDataPorts[safe: 0], let port2 = nodePageData.nodeCanvasData.nodes[safe: 2]?.inDataPorts[safe: 1] {
            port1.connectTo(anotherPort: port2)
        }
        if let port1 = nodePageData.nodeCanvasData.nodes[safe: 3]?.outDataPorts[safe: 0] as? CGVectorNodeDataPort {
            port1.value = CGVector(dx: 0, dy: 80)
        }

    }
    
    func destroy(nodePageData : NodePageData) {
        nodePageData.liveScene.removeAllChildren()
        nodePageData.nodeCanvasData.destroy()
    }
}
