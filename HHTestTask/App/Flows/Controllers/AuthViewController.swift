//
//  AuthViewController.swift
//  HHTestTask
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackViewCenter: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на уведомления клавиатуры
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWasShown),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillBeHiden),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

}


// MARK: - Методы появления/скрытия клавиатуры

extension AuthViewController {
    
    // когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        moveStackView(notification: notification)
    }
    
    // когда клавиатура исчезает
    @objc func keyboardWillBeHiden(notification: Notification) {
        moveStackView(notification: notification)
    }
    
    // Здесь смещение можно реализовать с анимацией
    private func moveStackView(notification: Notification) {
        // получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        // получаем высоту видимого экрана
        var heightScreen: CGFloat {
            if #available(iOS 11.0, *) {
                let guide = view.safeAreaLayoutGuide
                return guide.layoutFrame.size.height
            } else {
                return view.bounds.height - topLayoutGuide.length
            }
        }
        //получаем нижний край стекВью
        let bottomEdgeStak = stackView.frame.origin.y + stackView.frame.height
        // получаем высоту от нижнего края экрана до низа стекВью
        let bottomHeight = (Int(heightScreen) - Int(bottomEdgeStak))
        // получаем разницу нижней высоты и высоты клавиатуры
        let difference = bottomHeight - Int(kbSize.height)
        // если разница отрицательна то двигаем стек на разницу
        if difference < 0 {
            stackViewCenter.constant += CGFloat(difference)
        } else {
            stackViewCenter.constant = 0
        }
        
        //TODO: исправить баг когда у iOS 10 при переходе на следующее поле вызывается клавиатура и стек падает
        
//        print("bottomEgeStak: \(bottomEdgeStak)")
//        print("bottomHeight: \(bottomHeight)")
//        print("diffetence: \(difference)")
//        print("hs: \(heightScreen)")
//        print("stack.center: \(stackView.center.y)")
//        print("stak.origin: \(stackView.frame.origin.y)")
//        print("stak.height: \(stackView.frame.height)")
//        print("view.origin: \(view.frame.origin.y)")
//        print("view.height: \(view.frame.height)")
    }

}
