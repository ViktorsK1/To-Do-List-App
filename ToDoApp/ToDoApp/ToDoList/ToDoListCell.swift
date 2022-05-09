//
//  ToDoListCell.swift
//  ToDoApp
//
//  Created by Виктор Куля on 01.05.2022.
//

import UIKit
import SnapKit

class ToDoListCell: UITableViewCell {

    let textInputLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.numberOfLines = 0
        return uiLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        accessoryType = .checkmark
        
        contentView.addSubview(textInputLabel)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        textInputLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func apply(text: String) {
        textInputLabel.text = "\(text)"
    }
}
