//
//  AlertWarning.swift
//  HHTestTask
//
//  Created by Maxim Tolstikov on 16/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

enum AlertWarning: String {
    
    case locationError = "Неудалось получить данные местаположения!"
    case fetchError = "Неудалось загрузить данные о погоде из интернета!"
    case unsuitableEmail = "E-mail должен соответствовать text@text.te"
    case unsuitablePassword = "Пароль должен содержать минимум шесть символов, бльшую, маленькую букву и цыфру!"
}
