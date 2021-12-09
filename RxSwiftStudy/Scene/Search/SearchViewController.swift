//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by MK-Mac-210 on 2021/12/03.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: UIViewController, UITableViewDelegate {

  private let disposeBag = DisposeBag()

  private let switchButton: UISwitch = {
    let s = UISwitch()
    s.translatesAutoresizingMaskIntoConstraints = false
    return s
  }()

  private let textField: TextField = {
    let t = TextField()
    t.placeholder = "Search Repository"
    t.layer.cornerRadius = 8
    t.layer.borderColor = UIColor.gray.cgColor
    t.layer.borderWidth = 1
    t.translatesAutoresizingMaskIntoConstraints = false
    return t
  }()

  private let tableView = UITableView()

  private let viewModel = SearchViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.bind()
    self.configureTableView()
    self.addViews()
    self.layoutSubViews()
  }

  private func bind() {
    self.tableView.rx.setDelegate(self)

    let dataSource = RxTableViewSectionedReloadDataSource<RepositorySearchSection>(
      configureCell: { dataSource, tableView, indexPath, item in
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchResultCell {
          cell.update(with: item)
          return cell
        } else {
          fatalError()
        }
    })

    self.textField.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe (onNext: { query in
        self.viewModel.search(query: query)

        if self.viewModel.searchResponse.value.count > 0 {
          self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }

      })
      .disposed(by: self.disposeBag)

    self.viewModel.searchResponse
      .asObservable()
      .observe(on: MainScheduler.instance)
      .map { [RepositorySearchSection(items: $0)] }
      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)

    self.tableView.rx.contentOffset
      .subscribe(onNext: { offset in
        let contentSize = self.tableView.contentSize.height - (self.tableView.bounds.height + self.tableView.contentInset.bottom)

        if contentSize * 0.7 < offset.y {
          if self.viewModel.isLoading == false {
            self.viewModel.loadMore(query: self.textField.text ?? "")
          }
        }
      })
      .disposed(by: self.disposeBag)

  }

  private func addViews() {
    self.view.addSubview(self.switchButton)
    self.view.addSubview(self.textField)
    self.view.addSubview(self.tableView)
  }

  private func layoutSubViews() {
    NSLayoutConstraint.activate([
      self.switchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      self.switchButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      self.switchButton.heightAnchor.constraint(equalToConstant: 30),
      self.switchButton.widthAnchor.constraint(equalToConstant: 30),

      self.textField.topAnchor.constraint(equalTo: self.switchButton.bottomAnchor, constant: 10),
      self.textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
      self.textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
      self.textField.heightAnchor.constraint(equalToConstant: 40),

      self.tableView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20),
      self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }

  private func configureTableView() {
    self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: "cell")
    self.tableView.translatesAutoresizingMaskIntoConstraints = false

    self.switchButton.addTarget(self, action: #selector(self.switchButtonAction), for: .touchUpInside)
  }

  @objc private func switchButtonAction() {
    let value = self.switchButton.isOn
    self.switchButton.setOn(!value, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

}
