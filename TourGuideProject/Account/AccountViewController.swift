//
//  TGMyAccountViewController.swift
//  TourGuideProject
//
//  Created by hyunndy on 2020/07/09.
//  Copyright © 2020 hyunndy. All rights reserved.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth
import Firebase
import YYBottomSheet

class AccountViewController: UIViewController {
    
    var scvAccount = UIScrollView()
    
    var tfID = UITextField()
    
    var tfPassword = UITextField()
    
    var ivAccount = UIImageView()
    
    var btnLogin = UIButton()
    
    var btnSignin = UIButton()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        setFrameView()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = "계정정보"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 제스처 등록
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapScreenForHidingKeyboard)).then {
            $0.numberOfTouchesRequired = 1
            $0.isEnabled = true
            $0.cancelsTouchesInView = false
        }
        
        scvAccount.addGestureRecognizer(singleTapGestureRecognizer)
        
        // 텍스트 필드 UI 상태에 맞춰서 업데이트
        let isLoggedIn = Auth.auth().currentUser != nil
        setTextFieledPerAuthState(isLoggedIn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setFrameView() {
        
        // 스크롤뷰
        self.view.addSubview(scvAccount)
        scvAccount.then {
            $0.isScrollEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setUpView() {
        // 이미지
        self.scvAccount.addSubview(ivAccount)
        ivAccount.then {
            $0.image = UIImage(named: "heart_full")
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.left.right.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        // 아이디
        self.scvAccount.addSubview(tfID)
        tfID.then { [unowned self] in
            $0.placeholder = "이메일"
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .left
            $0.layer.borderWidth = 1.0
            $0.borderStyle = .roundedRect
            $0.layer.borderColor = CGColor(srgbRed: 255, green: 192, blue: 203, alpha: 0)
            $0.autocorrectionType = .no
            $0.delegate = self
            $0.returnKeyType = .next
        }.snp.makeConstraints {
            $0.top.equalTo(ivAccount.snp.bottom).offset(50)
            $0.left.equalTo(self.view.safeAreaLayoutGuide).offset(25)
            $0.right.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
        }
        
        // 비밀번호
        self.scvAccount.addSubview(tfPassword)
        tfPassword.then { [unowned self] in
            $0.placeholder = "비밀번호"
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.borderStyle = .roundedRect
            $0.textAlignment = .left
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = CGColor(srgbRed: 255, green: 192, blue: 203, alpha: 0)
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/5, height: self.view.frame.height/5)
            $0.autocorrectionType = .no
            $0.isSecureTextEntry = true
            $0.delegate = self
            $0.returnKeyType = .done
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfID.snp.bottom).offset(10)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 로그인 버튼
        self.scvAccount.addSubview(btnLogin)
        btnLogin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("로그인", for: .normal)
            $0.addTarget(self, action: #selector(onLoginBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.tfPassword.snp.bottom).offset(25)
            $0.left.right.equalTo(self.tfID)
        }
        
        // 회원가입 버튼
        self.scvAccount.addSubview(btnSignin)
        btnSignin.then { [unowned self] in
            $0.backgroundColor = .lightGray
            $0.setTitle("회원가입", for: .normal)
            $0.addTarget(self, action: #selector(onSigninBtnClicked(_:)), for: UIControl.Event.touchUpInside)
        }.snp.makeConstraints { [unowned self] in
            $0.top.equalTo(self.btnLogin.snp.bottom).offset(15)
            $0.left.right.equalTo(self.tfID)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func onLoginBtnClicked(_ sender: UIButton) {
        
        // 로그인
        if sender.title(for: .normal) == "로그인" {
            guard let email = tfID.text, let password = tfPassword.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user,error) in
                if user != nil {
                    self.showToast(message: "로그인 성공!")
                    self.setTextFieledPerAuthState(true)
                } else {
                    self.showToast(message: "로그인 실패!")
                }
            }
        }
        // 로그아웃
        else {
            do {
                try Auth.auth().signOut()
                self.showToast(message: "로그아웃 성공!")
                self.setTextFieledPerAuthState(false)
            } catch _ as NSError {
                self.showToast(message: "로그아웃 실패!")
            }
        }
    }
    
    // 회원가입 버튼 이벤트
    @objc func onSigninBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.present(SignUpViewController(), animated: true, completion: nil)
    }
    
    func showAlert(message: String?) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    
    func showToast(message: String) {
        let option: [YYBottomSheet.SimpleToastOptions:Any] = [
            .showDuration: 2.0,
            .backgroundColor: UIColor.black,
            .beginningAlpha: 0.8,
            .messageFont: UIFont.italicSystemFont(ofSize: 15),
            .messageColor: UIColor.white
        ]
        
        let simpleToast = YYBottomSheet.init(simpleToastMessage: message, options: option)
        
        simpleToast.show()
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfID {
            tfPassword.becomeFirstResponder()
        } else {
            tfPassword.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= 50
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if self.view.frame.origin.y < 0.0 {
            self.view.frame.origin.y += 50
        }
    }
    
    func setTextFieledPerAuthState(_ isLoggedIn : Bool) {
        
        // 로그인 체크
        if isLoggedIn {
            tfID.placeholder = "이미 로그인 된 상태입니다."
            tfPassword.placeholder = "이미 로그인 된 상태입니다."
            btnLogin.setTitle("로그아웃", for: .normal)
            btnSignin.isHidden = true
        } else {
            tfID.placeholder = "이메일"
            tfPassword.placeholder = "비밀번호"
            btnLogin.setTitle("로그인", for: .normal)
            btnSignin.isHidden = false
        }
    }
    
    @objc func tapScreenForHidingKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
