//
//  SearchService.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/06.
//

import RxSwift
import Moya

protocol SearchServiceType: AnyObject {
  func searchData(query: String, page: Int) -> Observable<RepositorySearchResponse>
}

final class SearchService: SearchServiceType {
  let provider = MoyaProvider<APIRequest>()

  func searchData(query: String, page: Int) -> Observable<RepositorySearchResponse> {
    return self.provider.rx.request(.searchList(query, page))
      .map(RepositorySearchResponse.self)
      .asObservable()
  }
}
