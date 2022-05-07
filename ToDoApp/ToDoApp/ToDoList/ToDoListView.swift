//
//  MainView.swift
//  ToDoApp
//
//  Created by Виктор Куля on 01.05.2022.
//

import UIKit
import SnapKit

class ToDoListView: UIView {

    let itemsTableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.separatorStyle = .singleLine
        return uiTableView
    }()
    
    let searchBarButton: UISearchBar = {
        let uiSearchBar = UISearchBar()
        uiSearchBar.placeholder = "Add item"
        uiSearchBar.backgroundColor = UIColor.systemIndigo
        return uiSearchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(itemsTableView)
        addSubview(searchBarButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        searchBarButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        itemsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton).offset(50)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

