//
//  CategoryCell.swift
//  ToDoApp
//
//  Created by Виктор Куля on 06.05.2022.
//

import UIKit

class CategoryCell: UITableViewCell {

    let categoryLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.numberOfLines = 0
        return uiLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(categoryLabel)
        
        makeContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeContstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func applyCategory(text: String) {
        categoryLabel.text = "\(text)"
    }
}
