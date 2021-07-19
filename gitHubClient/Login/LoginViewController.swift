//
//  LoginViewController.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit
import Kingfisher
import LocalAuthentication

final class LoginViewController: UIViewController {
    
    ///Сервис по умолчанию
    private static let serviceDefault = "gitHubClient"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tokenNotValid: UILabel!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if let userName = userName.text,
           !userName.isEmpty,
           let tmpTokenUser = password.text,
           !tmpTokenUser.isEmpty {
            
            authenticateGitHub(password: tmpTokenUser, userName: userName)
        }
    }
    
    ///Удалит из keyChain запись по имени пользователя
    @IBAction func deletePasswordTapHandler(sender: UIButton) {
        guard let account = userName.text, !account.isEmpty else {
            return
        }
        
        let result = deletePassword(userName: account)
        
        if result {
            print("password for account:\(account) successfully deleted")
        } else {
            print("can't delete password for account:\(account)")
        }
    }
    
    private var gitHubLogo = "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"
    
    private lazy var url = URL(string: gitHubLogo)

    override func viewDidLoad() {
        super.viewDidLoad()

        image.kf.setImage(with: url)
        tokenNotValid.isHidden = true
            
        //если в keychain не пусто, то вызвать TouchID
        if let tmpPasswords = readAllItems(),
           let tmpPassword = tmpPasswords.first?.value,
           let tmpUserName = tmpPasswords.first?.key {
            
            authenticateUser(passForGitHub: tmpPassword, userName: tmpUserName)
        }
    }
    
    ///Создание словаря keychain
    private func keychainQuery(service: String, account: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        //данные элемента в keychain могут быть доступны только тогда, когда устройство разблокировано пользователем, что является поведением по умолчанию
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        //Любой элемент в keychain имеет сервисное имя, которое является идентификатором для данных, которые вы собираетесь хранить в keychain
        query[kSecAttrService as String] = service as AnyObject
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
        
        return query
    }
    
    private func savePassword(password: String, service: String = serviceDefault, userName: String?) -> Bool {
        //конвертируем пароль в объект Data
        let passwordData = password.data(using: .utf8)
        
        //существует ли пароль для заданных сервиса и аккаунта
        if readPassword(service: service, account: userName) != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            
            let query = keychainQuery(service: service, account: userName)
            //Если да, мы обновляем его, используя метод SecItemUpdate
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keychainQuery(service: service, account: userName)
        item[kSecValueData as String] = passwordData as AnyObject
        //с помощью метода SecItemAdd добавляем пароль в keychain
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    private func readPassword(service: String = serviceDefault, account: String?) -> String? {
        var query = keychainQuery(service: service, account: account)
        //будет возвращен только первый элемент с заданными параметрами, найденный в keychain
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        //возвращать ли данные запрошенного элемента
        query[kSecReturnData as String] = kCFBooleanTrue
        //возвращать ли атрибуты элемента
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
                return nil
        }
        return password
    }
    
    ///Аутентификация по TouchID
    private func authenticateUser(passForGitHub: String, userName: String) {
        let authenticationContext = LAContext()
        setupAuthenticationContext(context: authenticationContext)
        
        let reason = "Fast and safe authentication in your app"
        var authError: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, evaluateError in
                if success {
                    // Пользователь успешно прошел аутентификацию
                    authenticateGitHub(password: passForGitHub, userName: userName)

                } else {
                    // Пользователь не прошел аутентификацию
                    if let error = evaluateError {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации
            if let error = authError {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        context.touchIDAuthenticationAllowableReuseDuration = 600
        
    }
    
    ///Аутентификация на GitHub
    private func authenticateGitHub(password: String, userName: String) {
        DispatchQueue.main.async {
            let uVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: UserViewController.self)) as UserViewController
            
            
            NetworkManager.tokenUser = password
            NetworkManager.performSearchUser { (user, statusCode) in
                
                if statusCode == 200, let user = user {
                    uVC.tmpUserName = user.userName
                    uVC.tmpAvatarURL = user.avatarURL
                    
                    let _ = self.savePassword(password: password, userName: userName)
                    
                    DispatchQueue.main.async {
                        self.tokenNotValid.isHidden = true
                        self.navigationController?.pushViewController(uVC, animated: true)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.tokenNotValid.text = "http status code: \(statusCode)"
                        self.tokenNotValid.isHidden = false
                    }
                }
            }
        }
    }
    
    ///Возвращает все записи из keyChain
    private func readAllItems(service: String = serviceDefault) -> [String : String]? {
        var query = keychainQuery(service: service)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let items = queryResult as? [[String : AnyObject]] else {
            return nil
        }
        var passwordItems = [String : String]()
        
        for (index, item) in items.enumerated() {
            guard let passwordData = item[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) else {
                    continue
            }
            
            if let account = item[kSecAttrAccount as String] as? String {
                passwordItems[account] = password
                continue
            }
            
            let account = "empty account \(index)"
            passwordItems[account] = password
        }
        return passwordItems
    }
    
    ///Удаление из keyChain записи по имени пользователя
    private func deletePassword(service: String = serviceDefault, userName: String?) -> Bool {
        let item = keychainQuery(service: service, account: userName)
        let status = SecItemDelete(item as CFDictionary)
        return status == noErr
    }
}
