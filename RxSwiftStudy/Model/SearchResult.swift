//
//  SearchResult.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/06.
//

import RxDataSources

struct RepositorySearchSection: Decodable {
  var items: [Item]
}

extension RepositorySearchSection: SectionModelType {
  typealias Item = RepositoryItem

  init(original: RepositorySearchSection, items: [RepositoryItem]) {
    self = original
    self.items = items
  }
}

struct RepositorySearchResponse: Decodable {
  var totalCount: Int?
  var incompleteResult: Bool?
  var items: [RepositoryItem]?

  enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case incompleteResult = "incomplete_results"
    case items
  }
}

struct RepositoryItem: Decodable, Hashable {
  static func == (lhs: RepositoryItem, rhs: RepositoryItem) -> Bool {
    return lhs.id == rhs.id &&
    lhs.name == rhs.name &&
    lhs.visibility == rhs.visibility &&
    lhs.score == rhs.score &&
    lhs.owner == rhs.owner
  }

  var id: Int
  var name: String
  var visibility: String
  var score: Int
  var owner: Owner
}

struct Owner: Decodable, Hashable {
  var avatarUrl: String?

  enum CodingKeys: String, CodingKey, Decodable {
    case avatarUrl = "avatar_url"
  }
}
