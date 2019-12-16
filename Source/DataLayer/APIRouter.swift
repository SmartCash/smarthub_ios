//
//  APIRouter.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Alamofire
import Foundation

protocol APIRouter: URLRequestConvertible {
  var baseURL: URL { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Parameters? { get }
  var encoding: ParameterEncoding { get }
  var headers: [String: String]? { get }
  var queryString: String? { get }
}

extension APIRouter {
  
  var parameters: Parameters? {
    return nil
  }
  
  var headers: [String: String]? {
    return nil
  }
  
  var queryString: String? {
    return nil
  }
}

protocol SmartcashWalletAPIRouter: APIRouter {}

extension SmartcashWalletAPIRouter {
  
  var baseURL: URL {
    return AppConfigStore.shared.smartcashBaseURL
  }
  
  func asURLRequest() throws -> URLRequest {
    
    
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = "/\(path)"
    
    if queryString != nil {
      urlComponents?.query = queryString
    }
    
    let url = urlComponents?.url
    var urlRequest = URLRequest(url: url!)
    
    
    

//    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    for (headerField, value) in headers ?? [:] {
      urlRequest.setValue(value, forHTTPHeaderField: headerField)
    }
    
    return try encoding.encode(urlRequest, with: parameters)
  }
  
  var encoding: ParameterEncoding {
    switch method {
    case .post:
      return JSONEncoding.default
    default:
      return URLEncoding.methodDependent
    }
  }
}

protocol ProposalsAPIRouter: APIRouter {}

extension ProposalsAPIRouter {
  
  var baseURL: URL {
    return AppConfigStore.shared.votingBaseURL
  }
  
  func asURLRequest() throws -> URLRequest {
    
    
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = "/\(path)"
    
    if queryString != nil {
      urlComponents?.query = queryString
    }
    
    let url = urlComponents?.url
    var urlRequest = URLRequest(url: url!)
    
    
    
    
    //    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    for (headerField, value) in headers ?? [:] {
      urlRequest.setValue(value, forHTTPHeaderField: headerField)
    }
    
    return try encoding.encode(urlRequest, with: parameters)
  }
  
  var encoding: ParameterEncoding {
    switch method {
    case .post:
      return JSONEncoding.default
    default:
      return URLEncoding.methodDependent
    }
  }
}
