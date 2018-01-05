//
//  Map.swift
//  Bgpath
//
//  Created by ubt on 2017/12/12.
//  Copyright © 2017年 qwz. All rights reserved.
//

import UIKit
import HandyJSON

enum SPType: Int, HandyJSONEnum {
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

class Sprite: NSObject, HandyJSON {
  var r: Int
  var c: Int
  var type: SPType
  
  required override init() {
    self.r = 0
    self.c = 0
    self.type = .grass
    super.init()
  }
  
  init(r: Int, c: Int, type: SPType = .grass) {
    self.r = r
    self.c = c
    self.type = type
  }
}

class Map: NSObject, HandyJSON {
  var rows: Int
  var columns: Int
  var sprites = [[Sprite]]()
  
  required override init() {
    self.rows = 6
    self.columns = 9
    super.init()
    resetSprites()
  }
  
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    super.init()
    resetSprites()
  }
  
  fileprivate func resetSprites() {
    sprites.removeAll()
    
    for i in 0..<rows {
      var rowSprites = [Sprite]()
      for j in 0..<columns {
        rowSprites.append(Sprite(r: i, c: j))
      }
      sprites.append(rowSprites)
    }
  }
  
  fileprivate func copySprites() -> [[Sprite]] {
    var newSprites = [[Sprite]]()
    
    for oldSprites in sprites {
      var rowSprites = [Sprite]()
      for oldSprite in oldSprites {
        rowSprites.append(oldSprite.copy() as! Sprite)
      }
      newSprites.append(rowSprites)
    }
    return newSprites
  }
}

// MARK: - NSCopying

extension Sprite: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return Sprite(r: r, c: c, type: type)
  }
}

extension Map: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    let newMap = Map(rows: rows, columns: columns)
    newMap.sprites = copySprites()
    return newMap
  }
}
