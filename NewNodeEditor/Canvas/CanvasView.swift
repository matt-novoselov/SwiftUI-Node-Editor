//
//  CanvasView.swift
//  NewNodeEditor
//
//  Created by Matt Novoselov on 19/03/24.
//

import SwiftUI

struct CanvasView: View {
    
    @Environment(NodeData.self)
    private var nodeData: NodeData
    
    @Environment(CanvasData.self)
    private var canvasData: CanvasData
    
    @State var maxZIndex: Double = 1
    
    var body: some View {
        
        ZStack{
            ForEach(nodeData.nodes){ node in
                BaseUINode(selectedNode: node, customOverlay: AnyView(createUINode(node: node)), maxZIndex: $maxZIndex)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .overlay {
            LinkingView()
        }
        .overlay{
            GeometryReader{ proxy in
                Color.clear
                    .onAppear(){
                        canvasData.canvasGeometry = proxy
                    }
            }
        }

    }
    
    // MARK:
    func createUINode(node: Node) -> some View {
        switch node {
        case let textNode as TextNode:
            return AnyView(TextUINode(selectedNode: textNode))
        case let imageNode as ImageNode:
            return AnyView(ImageUINode(selectedNode: imageNode))
        case let colorNode as ColorNode:
            return AnyView(ColorUINode(selectedNode: colorNode))
        case let opacityNode as OpacityNode:
            return AnyView(OpacityUINode(selectedNode: opacityNode))
        default:
            return AnyView(EmptyView())
        }
    }
    
}

#Preview {
    CanvasView()
        .environment(NodeData())
        .environment(CanvasData())
}
