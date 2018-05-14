//
//  ViewController.swift
//  Flo
//
//  Created by Jason on 13/05/2018.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 课程中提到的连接方式比较舒服,直接在storyboard中操作就可以了
    // 我一直都是打开代码和storyboard来进行连接的,有点low了
    // 不过btn事件还是要预先定义.... 高估了
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            // 教程中少判断了>8的情况
            if counterView.counter < 8 {
                counterView.counter += 1
            }
            
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }

}

