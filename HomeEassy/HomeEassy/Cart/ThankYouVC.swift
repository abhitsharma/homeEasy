//
//  ThankYouVC.swift
//  HomeEassy
//
//  Created by Macbook on 12/12/23.
//

import UIKit
import Lottie

protocol SuccessPayment{
    func moveToTrackOrder()
}

class ThankYouVC: UIViewController {
    @IBOutlet weak var animationView:UIView?
    var waveView:LottieAnimationView?
    var delegate: SuccessPayment?
    override func viewDidLoad() {
        super.viewDidLoad()
       setupAnimation()
       waveView?.play()
    }
    
    @IBAction func successFullyPaid(_ sender: UIButton) {
        self.dismiss(animated: true){
        self.tabBarController?.selectedIndex = 0
        self.delegate?.moveToTrackOrder()
        }
    }
    
    func setupAnimation(){
        let waveViewWidth: CGFloat = 120
           let waveViewHeight: CGFloat = 120
           waveView = LottieAnimationView(name: "success")
           waveView?.frame = CGRect(x: 0, y: 0, width: waveViewWidth, height: waveViewHeight)
           waveView?.center = CGPoint(x: animationView?.bounds.midX ?? 0, y: animationView?.bounds.midY ?? 0)
           waveView?.contentMode = .scaleAspectFit
           waveView?.loopMode = .playOnce
           waveView?.animationSpeed = 0.5
        animationView?.addSubview(waveView!)
    }

}
