import Alamofire
import Foundation

protocol Networking {
  typealias CompletionHandler = (Data?, Swift.Error?) -> Void

  func request(from: String, completion: @escaping CompletionHandler)
}

/// Модуль работы с сетью. Здесь можно настраивать сессию.
struct HTTPNetworking: Networking {
    
    func request(from: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request(from).response() { (response) in
            completion(response.data, response.error)
        }
    }

}
