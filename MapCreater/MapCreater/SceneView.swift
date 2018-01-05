//
//  SceneView.swift
//  Bgpath
//
//  Created by ubt on 2017/12/12.
//  Copyright © 2017年 qwz. All rights reserved.
//

import UIKit

private class NodeView: UIButton {
  var node: Sprite
  
  override var isSelected: Bool {
    didSet {
      backgroundColor = isSelected ? .red : .clear
    }
  }
  
  init(node: Sprite) {
    self.node = node
    super.init(frame: .zero)
    imageView?.contentMode = .scaleAspectFit
    setImage(node.type.image(), for: .normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SceneView: UIView {
  var map: Map? {
    didSet {
      render()
      setNeedsLayout()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    self.backgroundColor = UIColor.brown
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    render()
  }
  
  private func createView(for node: Sprite) -> NodeView {
    let view = NodeView(node: node)
    view.addTarget(self, action: #selector(onNodeView(_:)), for: .touchUpInside)
    return view
  }
  
  @objc private func onNodeView(_ sender: Any) {
    let nodeView = sender as! NodeView
    nodeView.isSelected = !nodeView.isSelected
  }
  
  func render() {
    func clearup() {
      for sub in subviews {
        sub.removeFromSuperview()
      }
    }
    clearup()
    
    guard let map = self.map else {
      return
    }
    let rows = map.rows
    let columns = map.columns
    let w = self.frame.size.width / CGFloat(columns)
    let h = self.frame.size.height / CGFloat(rows)
    
    for (i, rows) in map.sprites.enumerated() {
      for (j, node) in rows.enumerated() {
        let view = createView(for: node)
        view.frame = CGRect(
          origin: CGPoint(x: w*CGFloat(j), y: h*CGFloat(i)),
          size: CGSize(width: w, height: h))
        self.addSubview(view)
      }
    }
  }
  
  func selectedNodes() -> [Sprite] {
    var nodes = [Sprite]()
    
    for sub in subviews {
      if sub is NodeView {
        let nodeView = sub as! NodeView
        if nodeView.isSelected {
          nodes.append(nodeView.node)
        }
      }
    }
    return nodes
  }
}
