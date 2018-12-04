//
//  CustomMenuBar.swift
//  Doodletoss
//
//  Created by Kim Sunghyun on 2018. 12. 3..
//  Copyright © 2018년 Zaraza Inc. All rights reserved.
//

import UIKit
import SnapKit

protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}

class CustomMenuBar: UIView {
    weak var delegate: CustomMenuBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.initUI()
        self.initCollectionView()
        self.setData(data: ["Custom MenuBar"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI ------------------------------------------
    let cellName = "CustomMenuBarCell"
    var didSetupConstraints = false
    var indicatorHeight = 2
    var indicatorColor = UIColor.black
    var nowIndex = 0
    var menuData = [String]()
    fileprivate var collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout().then {$0.scrollDirection = .horizontal}).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    fileprivate var indicatorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.backgroundColor = .black
        $0.clipsToBounds = true
    }
    
    public func getTabWidth() -> CGFloat {
        if menuData.count < 1 {
            return self.frame.width
        } else {
            return self.frame.width / CGFloat(menuData.count)
        }
    }
    
    public func setIndicatorHeight(_ height: Int){
        indicatorHeight = height
        self.remakeIndicator()
    }
    
    public func setIndicatorColor(_ color:UIColor){
        indicatorColor = color
        indicatorView.backgroundColor = indicatorColor
    }

    public func setData(data: [String]) {
        menuData = data
        collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        self.nowIndex = 0
        self.remakeIndicator()
        self.setNeedsDisplay()
    }
}

extension CustomMenuBar {
    func initUI() {
        self.addSubview(collectionView)
        self.addSubview(indicatorView)
    }
    
    override var bounds: CGRect{
        didSet {
            if (!didSetupConstraints) {
                collectionView.snp.makeConstraints {
                    $0.left.equalTo(self.snp.left)
                    $0.right.equalTo(self.snp.right)
                    $0.top.equalTo(self.snp.top)
                    $0.height.equalTo(self.snp.height)
                }
                indicatorView.snp.makeConstraints{
                    $0.width.equalTo(getTabWidth())
                    $0.left.equalTo(getTabWidth() * CGFloat(nowIndex))
                    $0.height.equalTo(indicatorHeight)
                    $0.bottom.equalTo(self.snp.bottom)
                }
                didSetupConstraints = true
            }
        }
    }
    
    fileprivate func remakeIndicator() {
        if didSetupConstraints {
            indicatorView.snp.remakeConstraints{
                $0.width.equalTo(getTabWidth())
                $0.left.equalTo(getTabWidth() * CGFloat(nowIndex))
                $0.height.equalTo(indicatorHeight)
                $0.bottom.equalTo(self.snp.bottom)
            }
        }
    }
}

//MARK:- UICollectionViewDelegate, DataSource
extension CustomMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomMenuBarCell.self, forCellWithReuseIdentifier: self.cellName)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellName, for: indexPath) as! CustomMenuBarCell
        cell.bind(text: menuData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getTabWidth() , height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if nowIndex != indexPath.row {
            nowIndex = indexPath.row
            delegate?.customMenuBar(scrollTo: nowIndex)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.remakeIndicator()
                self.layoutIfNeeded()
            }, completion: { success in
                self.setNeedsLayout()
            })
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CustomMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class CustomMenuBarCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet{
            self.label.textColor = isSelected ? .black : .lightGray
        }
    }
    
    func bind(text: String?) {
        self.label.text = text
    }
    
    fileprivate var label = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
}

extension CustomMenuBarCell {
    func setupUI() {
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
}
