/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {
  
  var isGraphViewShowing = false

  //Counter outlets
  @IBOutlet weak var counterView: CounterView!
  @IBOutlet weak var counterLabel: UILabel!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var graphView: GraphView!
    
  @IBAction func pushButtonPressed(_ button: PushButton) {
    if button.isAddButton {
        if counterView.counter < 8 {
            counterView.counter += 1
        }
    } else {
      if counterView.counter > 0 {
        counterView.counter -= 1
      }
    }
    counterLabel.text = String(counterView.counter)
    if isGraphViewShowing {
        counterViewTap(nil)
    }
  }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            // hide Graph
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion:nil)
        } else {
            // show Graph
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    counterLabel.text = String(counterView.counter) 
  }
  
}

