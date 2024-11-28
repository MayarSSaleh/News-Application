//
//  Alart.swift
//  News App Task
//
//  Created by mayar on 26/11/2024.
//

import Foundation
import UIKit
import Lottie

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Sorry", message: "No Internet Connection. Please check your network and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func playLottieAnimation(animationView: LottieAnimationView) {
         animationView.frame = view.bounds
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .loop
         view.addSubview(animationView)
         animationView.play()
     }
}
