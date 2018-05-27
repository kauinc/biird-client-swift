//
//  BiirdClient.swift
//  Biird Swift Api Demo
//
//  Created by Think on 11/2/17.
//  Copyright © 2017 Think. All rights reserved.
//

import Foundation
import Alamofire
extension Dictionary {
    
    func merge(with dict: Dictionary<Key,Value>?) -> Dictionary<Key,Value> {
        var mutableCopy = self
        guard let dict = dict else {return mutableCopy}
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
    
    func merge(with dict: Dictionary<Key,Value?>?) -> Dictionary<Key,Value> {
        
        var mutableCopy = self
        guard let dict = dict else {return mutableCopy}
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}

class Entity {
    let data: Data;
    init(data:Data){
        self.data = data
    }
    var image: UIImage?{
        return UIImage(data: data, scale:1)
    }
    
    var text: String?{
        return String(data: data, encoding: String.Encoding.utf8)
    }
}


class Biird {
    static let shared = Biird()
    
    
    var languageCode: String { return NSLocale.components(fromLocaleIdentifier: NSLocale.preferredLanguages[0])["kCFLocaleLanguageCodeKey"] ?? "en" }
    
    var countryCode: String { return NSLocale.components(fromLocaleIdentifier: NSLocale.preferredLanguages[0])["kCFLocaleCountryCodeKey"] ?? "us" }
    
    var defaultLanguageDimensions: [String: String] {
        return ["language":languageCode]
    }
    
    
    
    // var useSystemLanguage = true
    
    private var baseUrl = NSURL(string: "https://api.biird.io/resourceValue/")!
    private var accessToken: String?
    var defaultDimensions = [String: String]()
    func configureWithAccessToken(accessToken:String){
        self.accessToken = accessToken
    }
    
    func fetch(withId id: String, dimensions:[String: String?]? = nil, completionHandler:@escaping ((Entity?) -> Void)) {
        SessionManager.default.startRequestsImmediately = true
        
        var resultDimensions: Parameters =                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          defaultDimensions.merge(with:dimensions)
        
        if (resultDimensions["language"] == nil) {
            resultDimensions = resultDimensions.merge(with: defaultLanguageDimensions)
        }
        
        guard let url = baseUrl.appendingPathComponent(id) else {return}
     
        
        Alamofire.request(url, method: .get, parameters: resultDimensions, encoding: URLEncoding.default, headers:nil).response { (dataResponse) in
            guard let data = dataResponse.data else {completionHandler(nil); return;}
            completionHandler(Entity(data:data))
        }

        
    }
    
    func fetch(withIds ids: [String], dimensions:[String: String?]? = nil, completionHandler:@escaping (([String:Entity]) -> Void)) {
        var result = [String:Entity]()
        
        let serviceGroup = DispatchGroup();
        for id in ids {
            serviceGroup.enter()
            fetch(withId: id, dimensions: dimensions, completionHandler: { (entity) in
                if let entity = entity {
                    result[id] = entity
                }
                
                serviceGroup.leave()
            })
        }
        serviceGroup.notify(queue: DispatchQueue.main) {
            completionHandler(result)
        }
        
    }
    ///Convenience image fetcher
    func fetchImage(withId id: String, dimensions:[String: String?]? = nil, completionHandler:@escaping ((UIImage?) -> Void)) {
        
        fetch(withId: id, dimensions: dimensions) {
            completionHandler( $0?.image)
        }
        
    }
}
