//
//  CategoryView.swift
//  ToDoApp
//
//  Created by Виктор Куля on 06.05.2022.
//

import UIKit
import SnapKit

class CategoryView: UIView {
    
    let categoryTableView: UITableView = {
        let uiTableView = UITableView()
        uiTableView.separatorStyle = .singleLine
        return uiTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        
        addSubview(categoryTableView)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        categoryTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
