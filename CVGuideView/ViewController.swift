//
//  ViewController.swift
//  CVGuideView
//
//  Created by caven on 2018/10/11.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 80))
        label.text = "首页"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor.black
        self.view.addSubview(label)

    }


}

