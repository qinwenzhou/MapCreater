//
//  Map.swift
//  Bgpath
//
//  Created by ubt on 2017/12/12.
//  Copyright © 2017年 qwz. All rights reserved.
//

import UIKit
import HandyJSON

enum Sprite: Int, HandyJSONEnum {
  case grass
  case tree
  case flower
  case floor
  case bird
  case stone
  case water
  
  func title() -> String {
    switch self {
    case .grass:
      return "草坪"
    case .tree:
      return "树木"
    case .flower:
      return "花朵"
    case .floor:
      return "地板"
    case .bird:
      return "小鸟"
    case .stone:
      return "石头"
    case .water:
      return "水池"
    }
  }
  
  func image() -> UIImage? {
    switch self {
    case .grass:
      return UIImage(named: "grass")
    case .tree:
      return UIImage(named: "tree")
    case .flower:
      return UIImage(named: "flower")
    case .floor:
      return UIImage(named: "floor")
    case .bird:
      return UIImage(named: "bird")
    case .stone:
      return UIImage(named: "stone")
    case .water:
      return UIImage(named: "water")
    }
  }
}

class Node: NSObject, HandyJSON {
  var r: Int
  var c: Int
  var sprite: Sprite
  
  required override init() {
    self.r = 0
    self.c = 0
    self.sprite = .grass
    super.init()
  }
  
  init(r: Int, c: Int, sprite: Sprite = .grass) {
    self.r = r
    self.c = c
    self.sprite = sprite
  }
}

class Map: NSObject, HandyJSON {
  var rows: Int
  var columns: Int
  var nodes = [[Node]]()
  
  required override init() {
    self.rows = 6
    self.columns = 9
    super.init()
    resetNodes()
  }
  
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    super.init()
    resetNodes()
  }
  
  fileprivate func resetNodes() {
    nodes.removeAll()
    
    for i in 0..<rows {
      var rowNodes = [Node]()
      for j in 0..<columns {
        rowNodes.append(Node(r: i, c: j))
      }
      nodes.append(rowNodes)
    }
  }
  
  fileprivate func copyNodes() -> [[Node]] {
    var newNodes = [[Node]]()
    
    for oldNodes in nodes {
      var rowNodes = [Node]()
      for oldNode in oldNodes {
        rowNodes.append(oldNode.copy() as! Node)
      }
      newNodes.append(rowNodes)
    }
    return newNodes
  }
}

// MARK: - NSCopying

extension Node: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return Node(r: r, c: c, sprite: sprite)
  }
}

extension Map: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    let newMap = Map(rows: rows, columns: columns)
    newMap.nodes = copyNodes()
    return newMap
  }
}
