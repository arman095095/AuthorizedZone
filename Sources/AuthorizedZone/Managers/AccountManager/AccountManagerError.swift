//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation

public enum AccountManagerError: LocalizedError {
    
    case another(error: Error)
    case profile(value: Profile)
    case recover(value: Recover)
    
    public enum Recover: LocalizedError {
        case cantRecover
        public var errorDescription: String? {
            switch self {
            case .cantRecover:
                return "Ошибка при попытке восстановления профиля"
            }
        }
    }
    
    public enum Profile: LocalizedError {
        case emptyProfile
        case profileRemoved
        case another(error: Error)
        public var errorDescription: String? {
            switch self {
            case .emptyProfile:
                return "Ошибка получения данных"
            case .profileRemoved:
                return "Вы удалили профиль"
            case .another(error: let error):
                return error.localizedDescription
            }
        }
    }
}

