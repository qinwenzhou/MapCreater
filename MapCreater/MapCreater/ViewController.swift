//
//  ViewController.swift
//  MapCreator
//
//  Created by ubt on 2017/12/12.
//  Copyright © 2017年 qwz. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "Cell"

class ViewController: UIViewController {
  @IBOutlet weak var sceneView: SceneView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let sprites: [Sprite] =
    [.grass, .tree, .flower, .floor, .bird, .stone, .water]
  
  var map: Map!
  var sureMap: Map!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reset()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func reset() {
    /*
    do {
      if let filePath = Bundle.main.path(forResource: "test.json", ofType: nil) {
        let json = try String(contentsOfFile: filePath, encoding: .utf8)
        if let m = Map.deserialize(from: json) {
          map = m
          sureMap = map.copy() as! Map
          
          sceneView.map = map
        }
      }
    } catch let error {
      print("\(error)")
    }*/
    
    map = Map(rows: 6, columns: 9)
    sureMap = map.copy() as! Map
    
    sceneView.map = map
  }
  
  @IBAction func onReset(_ sender: Any) {
    let alert = UIAlertController(title: nil, message: "确定要重置吗", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "不重置", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
      self.reset()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func onCancel(_ sender: Any) {
    let alert = UIAlertController(title: nil, message: "确定要撤销吗", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "不撤销", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
      self.map = self.sureMap.copy() as! Map
      self.sceneView.map = self.map
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func onDone(_ sender: Any) {
    let alert = UIAlertController(title: nil, message: "确定生成地图吗", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "不生成", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
      self.sureMap = self.map.copy() as! Map
      if let json = self.sureMap.toJSONString() {
        print("\(json)")
        SVProgressHUD.showSuccess(withStatus: "已生成")
      } else {
        SVProgressHUD.showSuccess(withStatus: "生成失败")
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }
}

class SpriteCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textLabel: UILabel!
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sprites.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sprite = sprites[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpriteCell
    cell.imageView.contentMode = .scaleAspectFit
    cell.imageView.image = sprite.image()
    cell.textLabel.text = sprite.title()
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 70)
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Selectioin animation
    let cell = collectionView.cellForItem(at: indexPath) as! SpriteCell
    let animation = CABasicAnimation(keyPath: "transform")
    animation.autoreverses = true
    animation.duration = 0.15
    animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.35, 1.35, 1))
    cell.layer.add(animation, forKey: nil)
    
    // Update sprite
    let nodes = sceneView.selectedNodes()
    guard nodes.count > 0 else {
      return
    }
    let sprite = sprites[indexPath.row]
    for node in nodes {
      node.sprite = sprite
    }
    sceneView.render()
  }
}
