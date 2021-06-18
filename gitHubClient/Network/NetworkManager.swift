//
//  NetworkManager.swift
//  networking
//
//  Created by cladendas on 03.03.2021.
//

import UIKit

final class NetworkManager {
    
    static var key = ""
    static var language = ""
    ///Как сортировать: 0 - по возрастанию, 1 - по убыванию, по умолчанию = 0
    static var order = 0
    
    private static let schema = "https"
    private static let host = "api.github.com"
    private static let searchRepoPath = "/search/repositories"
    private static let searchUser = "/user"
    
    static var tokenUser = ""
    
    private static let tokenHeader = ["Authorization" : "token \(tokenUser)"]
    
    private static let deafaultHeader = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    ///создание запроса с параметрами для получения списка репозиториев
    private static func requestRepo() -> URLRequest? {
        //URLComponents() позволяет создать URL из составных частей
        var urlComponents = URLComponents()
        urlComponents.scheme = schema
        urlComponents.host = host
        urlComponents.path = searchRepoPath
        
        //в массиве отражаются все необходимые для запроса элементы в порядке, в котором они следуют в поисковой строке
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(key)+language:\(language)"),
//            URLQueryItem(name: "q", value: "doom+language:ruby"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "\(order == 0 ? "asc" : "desc")")
        ]
        
        guard let url = urlComponents.url else { return nil}
        
        print("search request url: \(url)")
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = deafaultHeader
        
        return request
    }
    
    ///Выполнение запроса в соответствии с полученными настройками от request()
    static func performSearchRepoRequest(complition: @escaping (_ repositories: [Repository]) -> ()) {
        
        var repositories: [Repository] = []
        
        guard let urlRequest = requestRepo() else {
            print("url request error")
            return
        }
        
        //создание сессии и выполнение запроса
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as?  Dictionary<String, Any> {
                    let tmpRepositories = json["items"] as? [Dictionary<String, Any>]
                    
                    //Преобразование каждого элемента массива tmpRepositories в элемент с типом Repository и добавление его в массив repositories
                    tmpRepositories?.forEach({
                        guard let tmp = Repository(json: $0) else { return }
                        repositories.append(tmp)
                    })
                
                    complition(repositories)
                }
            } catch {
                print(error)
            }
            
            guard let _ = String(data: data, encoding: .utf8) else {
                print("data encoding failed")
                return
            }
        }
        dataTask.resume()
    }
    
    ///создание запроса для авторизации пользователя по токену
    private static func requestUser() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = schema
        urlComponents.host = host
        urlComponents.path = searchUser
        
        guard let url = urlComponents.url else { return nil}
        
        print("search request url: \(url)")
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = tokenHeader
        
        return request
    }
    
    ///выполнение запроса requestUser()
    static func performSearchUser(complition: @escaping (_ user: User) -> ()) {
        
        guard let urlRequest = requestUser() else {
            print("url request error")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("no data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as?  Dictionary<String, Any> {
                    
                    if let user = User(json: json) {
                        complition(user)
                    }
                }
            } catch {
                print(error)
            }
            
            guard let _ = String(data: data, encoding: .utf8) else {
                print("data encoding failed")
                return
            }
        }
        dataTask.resume()
    }
}
