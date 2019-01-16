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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var networkService: Fetcher?
    var locationService: LocationService?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // изменяем поведение скроллВью что бы контент не уходил под навигэшн
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        
        // Отписываемся от всех уведомлений
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        run()
    }
    
    
    private func run() {
        
        // валидируем поля формы
        guard let email = emailTextField.text, email.isValidEmail() else {
            alertWith(title: .warning, body: AlertWarning.unsuitableEmail.rawValue)
            return
        }
        guard let password = passwordTextField.text, password.isValidPassword() else {
            passwordTextField.text = ""
            alertWith(title: .warning, body: AlertWarning.unsuitablePassword.rawValue)
            return
        }
        //делаем запрос погоды
        fetchData()
    }
    
    private func fetchData() {
        guard let networkService = networkService, let locationService = locationService else {
            assertionFailure()
            return
        }
        guard let coordinates = locationService.currentCoordinates() else {
            alertWith(title: .warning, body: AlertWarning.locationError.rawValue)
            return
        }
        
        networkService.fetch(for: coordinates, response: { [weak self] (weather) in
            guard let weather = weather else {
                self?.alertWith(title: .warning, body: AlertWarning.fetchError.rawValue)
                return
            }
            let output = "Температура: \(weather.temperatureString)\nДавлление: \(weather.pressereString)\nВлажность: \(weather.humidityString)"
            self?.alertWith(title: .weather, body: output)
        })
    }
    
    private func alertWith(title: AlertTitle, body: String) {
        let alertController = UIAlertController(title: title.rawValue,
                                                message: body,
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
}


// MARK: - Методы появления/скрытия клавиатуры

extension AuthViewController {
    
    // когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        moveStackView(notification: notification)
    }
    
    // когда клавиатура исчезает возвращаем стэкВью в исходное положение
    @objc func keyboardWillBeHiden(notification: Notification) {
        stackViewCenter.constant = 0
    }
    
    // Здесь смещение можно реализовать с анимацией
    private func moveStackView(notification: Notification) {
        stackViewCenter.constant = 0
        
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
        }
    }

}


extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.keyboardType {
        case .emailAddress:
            guard let email = textField.text, email.isValidEmail() else {
                alertWith(title: .warning, body: AlertWarning.unsuitableEmail.rawValue)
                return false
            }
            textField.resignFirstResponder()
            return true
        case .default:
            guard let password = passwordTextField.text, password.isValidPassword() else {
                passwordTextField.text = ""
                alertWith(title: .warning, body: AlertWarning.unsuitablePassword.rawValue)
                return false
            }
            textField.resignFirstResponder()
            run()
            return true
        default:
            return false
        }
    }
    
}
