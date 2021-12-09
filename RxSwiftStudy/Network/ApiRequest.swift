//
//  ApiRequest.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/06.
//

import Moya

enum APIRequest {
  case searchList(String, Int)
}

extension APIRequest: TargetType {
  var baseURL: URL {
    return URL(string: "https://api.github.com/")!
  }

  var path: String {
    switch self {
    case .searchList:
      return "search/repositories"
    }
  }

  var method: Method {
    switch self {
    case .searchList:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .searchList(let query, let page):
      return .requestParameters(
        parameters: ["page" : page, "q": query],
        encoding: URLEncoding.default
      )
    }
  }

  var headers: [String : String]? {
    return nil
  }

  var sampleData: Data {
    return Data()
  }
}
