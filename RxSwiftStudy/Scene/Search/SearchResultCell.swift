//
//  SearchResultCell.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/07.
//

import Foundation
import UIKit
import Kingfisher

class SearchResultCell: UITableViewCell {
  let nameLabel: UILabel = {
    let name = UILabel()
    name.translatesAutoresizingMaskIntoConstraints = false
    return name
  }()

  let avatarImageView: UIImageView = {
    let i = UIImageView()
    i.contentMode = .scaleToFill
    i.clipsToBounds = true
    i.translatesAutoresizingMaskIntoConstraints = false
    return i
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.addView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addView() {
    self.contentView.addSubview(self.avatarImageView)
    self.contentView.addSubview(self.nameLabel)
    NSLayoutConstraint.activate([
      self.avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
      self.avatarImageView.widthAnchor.constraint(equalToConstant: 30),
      self.avatarImageView.heightAnchor.constraint(equalToConstant: 30),

      self.nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      self.nameLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 10)
    ])
  }

  func update(with item: RepositoryItem?) {
    if let urlString = item?.owner.avatarUrl,
        let imageUrl = URL(string: urlString) {
      self.avatarImageView.kf.setImage(with: imageUrl)
    }

    self.nameLabel.text = item?.name
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.avatarImageView.kf.cancelDownloadTask()
  }
}

