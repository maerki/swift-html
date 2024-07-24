//
//  Node.swift
//  SwiftHtml
//
//  Created by Tibor Bodecs on 2021. 07. 19..
//

public struct Node {

    /// internal node types
    public enum NodeType {
        /// standard container tags
        case standard     // <div>  </div>
        /// comment tag
        case comment      // <!--   -->
        // @TODO: force close tags? <br> vs <br/>
        /// non-container tags
        case empty        // <br>
        /// invisible node for grouping other nodes
//        case group    // *invisible group*<h1>lorem</h1><p>ipsum</p>*invisible group*
        case raw
    }

    public var type: NodeType
    public var name: String?
    public var contents: String?
    public var attributes: [Attribute]
    public var children: [Node]

    public init(type: NodeType = .standard,
         name: String? = nil,
         contents: String? = nil,
         attributes: [Attribute] = [],
         children: [Node] = []
    ) {
        self.type = type
        self.name = name
        self.contents = contents
        self.attributes = attributes
        self.children = children
    }

    public var html: String {
        switch type {
        case .standard:
            var htmlValue = children.map(\.html).joined(separator: "")
            if !children.isEmpty {
                htmlValue = htmlValue + "\n"
            }
            return "\n<" + name! + (attributes.isEmpty ? "" : " ") + attributesList + ">" + (contents ?? "") + htmlValue + "</" + name! + ">"
        case .comment:
            return "\n<!--" + (contents ?? "") + "-->"
        case .empty:
            return "\n<" + name! + (attributes.isEmpty ? "" : " ") + attributesList + ">"
        case .raw:
            return contents ?? ""
//        case .group:
//            var htmlValue = children.map(\.html).joined(separator: "")
//            if !children.isEmpty {
//                htmlValue = htmlValue + "\n"
//            }
//            return htmlValue
        }
    }
    
    private var attributesList: String {
        return attributes.reduce([]) { res, next in
            if let value = next.value {
                return res + [next.key + #"=""# + value + #"""#]
            }
            return res + [next.key]
        }.joined(separator: " ")
    }
}

extension Node {
    
    func addOrReplace(_ attribute: Attribute) -> Node {
        var newNode = self
        newNode.attributes = newNode.attributes.filter { $0.key != attribute.key }
        newNode.attributes.append(attribute)
        return newNode
    }

    func remove(_ attribute: Attribute) -> Node {
        var newNode = self
        newNode.attributes = newNode.attributes.filter { $0.key != attribute.key }
        return newNode
    }
}

