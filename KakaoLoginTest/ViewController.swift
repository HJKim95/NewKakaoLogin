//
//  ViewController.swift
//  KakaoLoginTest
//
//  Created by 김희중 on 2021/05/04.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    
    lazy var kakaoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "kakao_login_medium_narrow")
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginKakao)))
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(kakaoImageView)
        kakaoImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        kakaoImageView.center = view.center
        
        view.addSubview(userInfoLabel)
        userInfoLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        userInfoLabel.center = CGPoint(x: view.center.x, y: view.center.y + 50)
    }
    
    @objc private func loginKakao() {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error = error {
                    print(error)
                }
                else {
                    print("LoginWithKakaoTalk() Success!")
                    self?.setUserInfo()
                }
            }
        } else {
            AuthApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error = error {
                    print(error)
                }
                else {
                    print("LoginWithKakaoAccount() Success!")
                    self?.setUserInfo()
                }
            }
        }

    }
    
    private func setUserInfo() {
        UserApi.shared.me { [weak self] user, error  in
            if let error = error {
                print(error)
            }
            else {
                print("me() Success!")
                
                guard let email = user?.kakaoAccount?.email,
                      let id = user?.id
                else { return }
                self?.userInfoLabel.text = "EMAIL: \(email)\nID: \(String(describing: id))"
            }
        }
    }


}

