//
//  DataRequestExtensions.swift
//  SmartcashWallet
//
//  Created by Erick Vavretchek on 8/9/17.
//  Copyright © 2017 Erick Vavretchek. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

extension DataRequest {
  
  /**
   Much like Alamofire built-in `stringResponseSerializer` or `jsonResponseSerializer`,
   `swiftJsonResponseSerializer` is just a custom serializer that returns `SwiftyJSON.JSON` instead of `Any`.
   This serializer should be used instead of `Alamofire.jsonResponseSerializer` because it already wraps errors into `BackendError` or `SmartcashAPIError`.
   - returns: A SwiftyJSON response serializer.
   */
  static func swiftyJsonResponseSerializer() -> DataResponseSerializer<SwiftyJSON.JSON> {
    
    return DataResponseSerializer { request, response, data, error in
      
      let jsonSerializer = DataRequest.jsonResponseSerializer()
      let jsonSerializationResult = jsonSerializer.serializeResponse(request, response, data, nil)
      var json: JSON?
      
      if let jsonObject = jsonSerializationResult.value {
        json = SwiftyJSON.JSON(jsonObject)
      }
      
      if let error = error {
        if let error = error as? AFError, error.isUnauthorisedError {
//          if let errorType = json?["type"].string {
//            return .failure(SmartcashAPIError(apiErrorType: errorType))
//          }
//          else {
//            return .failure(SmartcashAPIError.unauthorized)
//          }
        }
        
        return .failure(BackendError(error: error))
      }
      
      if let json = json {
        return .success(json)
      }
      else {
        return .failure(BackendError.jsonSerialization(error: jsonSerializationResult.error!))
      }
    }
  }
  
  /**
   Much like Alamofire built-in `responseString` or `responseJSON`,
   `responseObject` adds a handler to be called once the request has finished. The handler will either contain a model object on an error.
   - parameter completionHandler: A closure to be executed once the request has finished.
   - returns: The request.
   */
  @discardableResult func responseSwiftyJson(completionHandler: @escaping (DataResponse<SwiftyJSON.JSON>) -> Void) -> Self {
    
    let responseSerializer = DataRequest.swiftyJsonResponseSerializer()
    let queue = DispatchQueue(label: "smartcash-response-queue", qos: .utility, attributes: .concurrent)
    
    return response(queue: queue, responseSerializer: responseSerializer) { response in
      DispatchQueue.main.async {
        completionHandler(response)
      }
    }
  }
}

extension DataRequest {
  
  /**
   Much like Alamofire built-in `stringResponseSerializer` or `jsonResponseSerializer`,
   `objectResponseSerializer` is just a custom serializer that parses objects conforming to `ResponseObjectSerializable`.
   This serializer goes one step further compared to `jsonResponseSerializer` by attempting to transform the JSON from the response into a model object.
   - returns: An object response serializer.
   */
  static func objectResponseSerializer<T: ResponseObjectSerializable>() -> DataResponseSerializer<T> {
    
    return DataResponseSerializer<T> { request, response, data, error in
      
      let jsonSerializer = DataRequest.swiftyJsonResponseSerializer()
      let result = jsonSerializer.serializeResponse(request, response, data, error)
      
      switch result {
        
      case .success(let json):
        guard let object = T(json: json) else {
          return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(json)"))
        }
        return .success(object)
      case .failure(let error):
        return .failure(error)
      }
    }
  }
  
  /**
   Much like Alamofire built-in `responseString` or `responseJSON`,
   `responseObject` adds a handler to be called once the request has finished. The handler will either contain a model object on an error.
   - parameter completionHandler: A closure to be executed once the request has finished.
   - returns: The request.
   */
  @discardableResult func responseObject<T: ResponseObjectSerializable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
    
    let responseSerializer: DataResponseSerializer<T> = DataRequest.objectResponseSerializer()
    let queue = DispatchQueue(label: "smartcash-response-queue", qos: .utility, attributes: .concurrent)
    
    return response(queue: queue, responseSerializer: responseSerializer) { response in
      DispatchQueue.main.async {
        completionHandler(response)
      }
    }
  }
}

extension DataRequest {
  
  static func collectionResponseSerializer<T: ResponseCollectionSerializable>() -> DataResponseSerializer<[T]> {
    
    return DataResponseSerializer<[T]> { request, response, data, error in
      
      let jsonSerializer = DataRequest.swiftyJsonResponseSerializer()
      let result = jsonSerializer.serializeResponse(request, response, data, error)
      
      switch result {
      case .success(let jsonArray):
        let objectCollection = T.collection(json: jsonArray)
        return .success(objectCollection)
      case .failure(let error):
        return .failure(error)
      }
    }
  }
  
  @discardableResult func responseCollection<T: ResponseCollectionSerializable>(completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
    
    let responseSerializer: DataResponseSerializer<[T]> = DataRequest.collectionResponseSerializer()
    let queue = DispatchQueue(label: "smartcash-response-queue", qos: .utility, attributes: .concurrent)
    
    return response(queue: queue, responseSerializer: responseSerializer) { response in
      DispatchQueue.main.async {
        completionHandler(response)
      }
    }
  }
}

extension AFError {
  var isUnauthorisedError: Bool {
    if
      case AFError.responseValidationFailed(let reason) = self,
      case AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code) = reason,
      code == 401 {
      return true
    }
    
    return false
  }
}


extension JSONDecoder {
  func decodeResponse<T: Decodable>(_ type: T.Type , from response: DataResponse<Data>) -> Result<T> {
    guard response.error == nil else {
      print(response.error!)
      return .failure(response.error!)
    }

    guard let responseData = response.data else {
      print("didn't get any data from API")
      return .failure(BackendError.codableData(reson: "Did not get data in response"))
    }

    do {
      let item = try decode(T.self, from: responseData)
      return .success(item)
    } catch {
      print("error trying to decode response")
      print(error)
      return .failure(error)
    }
  }
}

