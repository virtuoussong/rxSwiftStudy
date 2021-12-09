//
//  ViewModel.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/03.
//

import Foundation

import RxSwift
import RxCocoa

class SearchViewModel {
  let service = SearchService()
  var searchResponse = BehaviorRelay<[RepositoryItem]>(value: [])
  let disposeBag = DisposeBag()
  var page = 1
  var isLoading = false
  func search(query: String) {
    self.page = 1
    self.service.searchData(query: query, page: 1)
      .subscribe(onNext: { response in
        if let items = response.items {
          self.searchResponse.accept(items)
        }

        self.page = 2
      })
      .disposed(by: disposeBag)
  }

  func loadMore(query: String) {
    print("page number \(self.page)")

    guard !self.isLoading else { return }
    self.isLoading = true
    self.service.searchData(query: query, page: self.page)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: { response in
          if let items = response.items {
            let newArray = self.searchResponse.value + items
            self.searchResponse.accept(newArray.uniqued())
            
            let currentPage = self.searchResponse.value.count / 30
            self.page = currentPage + 1
          }

          print(response.incompleteResult)

          self.isLoading = false
        }
      )
      .disposed(by: disposeBag)
  }
}
