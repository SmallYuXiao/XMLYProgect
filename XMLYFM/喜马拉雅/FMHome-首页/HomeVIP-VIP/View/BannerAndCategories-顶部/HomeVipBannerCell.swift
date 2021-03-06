//
//  HomeVipBannerCell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/2.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
import FSPagerView
/// 添加cell点击代理方法
protocol HomeVipBannerCellDelegate:NSObjectProtocol {
    func homeVipBannerCellClick(url:String)
}

class HomeVipBannerCell: UITableViewCell {
    weak var delegate : HomeVipBannerCellDelegate?

    var vipBanner: [FocusImagesData]?
    
    // MARK: - 懒加载滚动图片浏览器
    private lazy var pagerView : FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval =  3
        pagerView.isInfinite = true
        pagerView.interitemSpacing = 15
        pagerView.transformer = FSPagerViewTransformer(type: .invertedFerrisWheel)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "HomeVipBannerCell")
        return pagerView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        self.pagerView.itemSize = CGSize.init(width: YYScreenWidth-60, height: 140)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var vipBannerList: [FocusImagesData]? {
        didSet {
            guard let model = vipBannerList else { return }
            self.vipBanner = model
            self.pagerView.reloadData()
        }
    }
}

extension HomeVipBannerCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // MARK:- FSPagerView Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.vipBanner?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomeVipBannerCell", at: index)
        cell.imageView?.kf.setImage(with: URL(string:(self.vipBanner?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let url:String = self.vipBanner?[index].link ?? ""
        delegate?.homeVipBannerCellClick(url: url)
    }
}
