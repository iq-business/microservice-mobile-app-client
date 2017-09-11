//
//  MockedPriceProvider.swift
//  beverage-maker-mobile-app
//
//  Created by Gerard de Jong on 2017/04/17.
//  Copyright © 2017 IQ Business. All rights reserved.
//

import Foundation

class NetworkBeverageInformationService : BeverageInformationService {
    
    var request: URLRequest
    
    init(endPoint: String) {
        request = URLRequest(url: URL(string: endPoint)!,
                             cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData,
                             timeoutInterval: TimeInterval(exactly: 3)!)
    }
    
    func getBeverageInformation(completion: @escaping (_ name: String?, _ description: String?, _ price: Double?, _ error: Error?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, nil, nil, NSError(domain:"", code:httpResponse.statusCode, userInfo:nil))
                }
                else {
                    if error != nil || httpResponse.statusCode != 200 {
                        completion(nil, nil, nil, error)
                    }
                    else {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                                completion(json["name"] as? String, json["description"] as? String, json["price"] as? Double, nil)
                            }
                        } catch {
                            completion(nil, nil, nil, error)
                        }
                    }
                }
            }
            else {
                completion(nil, nil, nil, NSError(domain:"", code:99, userInfo:nil))
            }
        })
        task.resume()
    }
}
