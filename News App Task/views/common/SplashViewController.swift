//
//  SplashViewController.swift
//  News App Task
//
//  Created by mayar on 26/11/2024.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {


    private let animationView = LottieAnimationView(name: "splashAnimation")


        override func viewDidLoad() {
            super.viewDidLoad()

            setupAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.navigateToMainScreen()
            }
        }

        private func setupAnimation() {
            animationView.frame = view.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            view.addSubview(animationView)

            animationView.play { [weak self] _ in
                self?.navigateToMainScreen()
            }
        }

        private func navigateToMainScreen() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController: UIViewController
            
            viewController = storyboard.instantiateViewController(withIdentifier: "tabBarView")
            
            // Transition to the selected screen
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
           
        }
    }
