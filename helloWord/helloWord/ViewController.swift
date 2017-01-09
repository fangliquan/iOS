//
//  ViewController.swift
//  helloWord
//
//  Created by leo on 2017/1/9.
//  Copyright © 2017年 microleo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func click(_ sender: UIButton, forEvent event: UIEvent) {
        let alert : UIAlertView = UIAlertView();
        alert.title = "提示";
        alert.message = "惦记我啊啊啊啊啊啊啊";
        alert.addButton(withTitle: "点击");
        alert.show();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

