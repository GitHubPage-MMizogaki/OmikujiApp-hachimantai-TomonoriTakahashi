//
//  ViewController.swift
//  OmikujiApp
//
//  Created by 高橋知憲 on 2016/11/12.
//  Copyright © 2016年 高橋知憲. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // iPhoneを振った音を出すための再生オブジェクトを格納します。
    var daikichiPlayer: AVAudioPlayer = AVAudioPlayer()

    
    @IBOutlet weak var stickView: UIView!
    @IBOutlet weak var stickLabel: UILabel!
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    @IBOutlet weak var stickBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var bigLabel: UILabel!
    
    let resultTextArray: [String] = [
        "大吉",
        "中吉"
    ]
    
    // アプリで使用する音の準備(大吉)
    func setupDaikichiSound(_ soundTitle:String)  {
        
        // iPhoneを振った時の音を設定します。
        if let sound = Bundle.main.path(forResource: soundTitle, ofType: ".mp3") {
            daikichiPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            daikichiPlayer.prepareToPlay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDaikichiSound("")
    }

    override func  motionEnded(_ motion: UIEventSubtype, with: UIEvent?){
        
        //次の処理の前に音声をストップ
        daikichiPlayer.stop()
        setupDaikichiSound("")

        
        if motion != UIEventSubtype.motionShake || overView.isHidden == false{
            // シェイクモーション以外では動作させない
            // 結果の表示中は動作させない

            return
        }
        
        
        let resultNum = Int( arc4random_uniform(UInt32(resultTextArray.count)) )
        stickLabel.text = resultTextArray[resultNum]
        stickBottomMargin.constant = stickHeight.constant * -1
        
        
        switch resultNum  {
        case 0 : //大吉のとき
            
            // 音の準備
            setupDaikichiSound("newtype")
            daikichiPlayer.play()
            
        default: //その他のとき
            
            setupDaikichiSound("jump01")
            daikichiPlayer.play()
            break
        }
        

        
        UIView.animate(withDuration: 1, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: { (finished: Bool) in
            
            self.bigLabel.text = self.stickLabel.text
            self.overView.isHidden = false
        })
        
    }
    
    @IBAction func tapRetryButton(_ sender: Any) {
        overView.isHidden = true
        stickBottomMargin.constant = 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

