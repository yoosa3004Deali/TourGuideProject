//
//  TGFestivalDetailViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/17.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class TGFestivalDetailViewController: UIViewController {

    // 스크롤뷰
    var scvFestival = UIScrollView()
    // 스택뷰
    var stvFestival = UIStackView()
    
    // 데이터
    var dataInfo = FestivalData()
    
    // 이미지뷰
    var ivDetail = UIImageView()
    // 제목
    var lbTitle = UILabel()
    // 주소(addr1 + addr2)
    var lbAddr = UILabel()
    // 전화번호
    var lbTel = UILabel()
    // 찜아이콘
    var imgFullHeart = UIImage(named: "heart_full.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    var imgEmptyHeart = UIImage(named: "heart_empty.png")?.resized(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
    
    func setUpViews() {
      
        // 스크롤뷰
        self.view.addSubview(scvFestival)
        scvFestival.then {
            $0.delegate = self
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택뷰
        self.scvFestival.addSubview(stvFestival)
        stvFestival.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        
        // 행사 이미지
        self.stvFestival.addSubview(ivDetail)
        ivDetail.then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(300)
        }
        
//        let processor = DownsamplingImageProcessor(size: ivDetail.bounds.size)
        ivDetail.kf.setImage(with: URL(string: dataInfo.image!), options: nil)//[.processor(processor)])
        
        // 행사 이름
        self.scvFestival.addSubview(lbTitle)
        lbTitle.then {
            $0.text = dataInfo.title
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.ivDetail.snp.bottom).offset(25)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        // 관광지 주소 뷰
        self.scvFestival.addSubview(lbAddr)
        lbAddr.then {
            if let str = dataInfo.addr1 {
                $0.text = str
                if let str2 = dataInfo.addr2 {
                    $0.text = str+str2
                }
            }
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.lbTitle)
            make.top.equalTo(self.lbTitle.snp.bottom).offset(25)
        }
        
        // 관광지 전화번호 뷰
        self.scvFestival.addSubview(lbTel)
        lbTel.then {
            $0.text = dataInfo.tel
            
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.lbAddr)
            make.top.equalTo(self.lbAddr.snp.bottom).offset(300)
            make.bottom.equalToSuperview()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        setUpViews()
        setNavItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

    }
    
    @objc func selectHeart(_ sender: UIBarButtonItem) {
          
        
        // 꽉찬하트
        if(sender.image == imgFullHeart) {
            sender.image = imgEmptyHeart
        } else {
            sender.image = imgFullHeart
        }
    }
    
    func setNavItem(){
        
        // 배경
        self.navigationController?.navigationBar.barTintColor = .orange

        // 제목
        self.title = dataInfo.title

        // 오른쪽 - 찜 아이콘
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imgEmptyHeart, style: .plain, target: self, action: #selector(selectHeart(_:)))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
    }

}

extension TGFestivalDetailViewController: UIScrollViewDelegate {
}


