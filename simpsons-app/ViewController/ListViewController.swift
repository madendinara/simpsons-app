//
//  ListViewController.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import UIKit

protocol ListViewControllerDelegate: class {
  func characterSelected(_ selectedCharacter: RelatedTopic)
}

class ListViewController : UIViewController, AlertView {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: ListViewControllerDelegate?
    let networkManager = Network()
    private var CharacterList: [RelatedTopic]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if let firstCharacter = self.CharacterList?[0] {
                    self.delegate?.characterSelected(firstCharacter)
                }
            }
        }
    }
    
    private var fileredList: [RelatedTopic]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        title = SharedInfo.shared.title
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defalultCellIdentifier)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapView(_:)))
        backgroundView.addGestureRecognizer(tap)

        fetchData()
    }
    
    @objc fileprivate func searchButtonTapped() {
        searchBarSearchButtonClicked(searchBar)
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    func fetchData() {
        networkManager.fetchDataWith() { [weak self] result in
            switch result {
            case .success(let characterData):
                DispatchQueue.main.async {
                    self?.CharacterList = characterData.relatedTopics
                    if (characterData.relatedTopics?.isEmpty ?? true) {
                        self?.alert(error: Errors.noResult)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.alert(error: error)
                }
            }
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.searchBar.text,
              !text.isEmpty,
              let searchText = text.removeWhiteSpaces(query: text),
              !searchText.isEmpty else {
            searchBar.text = nil
            self.tableView.reloadData()
            self.searchBar.resignFirstResponder()
            self.alert(error: Errors.emptySearchBar)
            return
        }
        self.searchBar.resignFirstResponder()

        let filter = self.CharacterList?.filter({ $0.text?.hasPrefix(searchText) ?? false})
        
        self.fileredList = filter
        
        self.tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
            return searchBar.text?.isEmpty ?? true
        }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBarIsEmpty() {
            return fileredList?.count ?? 0
        } else {
            return CharacterList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as?  ListCell else {
                   return UITableViewCell(style: .default, reuseIdentifier: Constants.defalultCellIdentifier)
                }
        let parts: [String.SubSequence]?
        let result: RelatedTopic?
        if !searchBarIsEmpty() {
            result = fileredList?[indexPath.row]
            parts = result?.text?.split(separator: "-")
        } else {
            result = CharacterList?[indexPath.row]
            parts = result?.text?.split(separator: "-")
        }
        
        if let title = parts?[0] {
            cell.characterName.text = String(title)
        } else {
            cell.characterName.text = "N/A"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searchBarIsEmpty() {
            if let selectedCharacter = fileredList?[indexPath.row] {
                delegate?.characterSelected(selectedCharacter)
                if
                  let detailViewController = delegate as? DetailsViewController,
                  let detailNavigationController = detailViewController.navigationController {
                    splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
                }
            }
        } else {
            if let selectedCharacter = CharacterList?[indexPath.row] {
                delegate?.characterSelected(selectedCharacter)
                if
                  let detailViewController = delegate as? DetailsViewController,
                  let detailNavigationController = detailViewController.navigationController {
                    splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
                }
            }
        }
    }
}
