//
//  MyTMDbViewController.swift
//  MovieDisplay
//
//  Created by Coco Wu on 2017/9/12.
//  Copyright © 2017年 cyt. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class MyTMDbViewController: UIViewController {
    
    fileprivate let viewModel = MyTMDbViewModel()
    fileprivate let accountTF = UITextField()
    fileprivate let pswTF = UITextField()
    fileprivate let loginBtn = UIButton()
    fileprivate let disposeBag = DisposeBag.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        accountTF.rx.text.subscribe { (event) in
            debugPrint(event)
        }.disposed(by: disposeBag)
        
        accountTF.borderStyle = .roundedRect
        accountTF.placeholder = "Account"
        pswTF.borderStyle = .roundedRect
        pswTF.placeholder = "password"
        loginBtn.backgroundColor = UIColor.red
        loginBtn.setTitle("User name or psw unavailiable", for: .disabled)
        loginBtn.setTitle("Login", for: .normal)
        
        // 绑定logbtn与输入框的关系
        Observable.combineLatest(accountTF.rx.text, pswTF.rx.text).map { (text) -> Bool in
            return ((text.0?.characters.count)! >= 3 && (text.1?.characters.count)! >= 6)
        }.subscribe({ (event) in
            self.loginBtn.isEnabled = event.element!
        }).addDisposableTo(disposeBag)
        
        // ViewModel 绑定UI
        viewModel.validateSubject.subscribe { (event) in
            debugPrint(event)
        }.addDisposableTo(disposeBag)
        
        // 绑定logBtn点击事件
        loginBtn.rx.tap.subscribe { (event) in
           self.viewModel.validateUserName(self.accountTF.text)
        }.addDisposableTo(disposeBag)
        
        view.addSubview(accountTF)
        view.addSubview(pswTF)
        view.addSubview(loginBtn)
        setupLayouts()
    }
    
    fileprivate func setupLayouts() {
        accountTF.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalTo(kScrrenHeight / 3)
            make.height.equalTo(45)
        }
        pswTF.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(accountTF)
            make.top.equalTo(accountTF.snp.bottom).offset(10)
            make.height.equalTo(accountTF)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(accountTF)
            make.top.equalTo(pswTF.snp.bottom).offset(20)
            make.height.equalTo(accountTF)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}