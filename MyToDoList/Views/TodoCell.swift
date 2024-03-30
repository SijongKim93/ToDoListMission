//
//  TodoCell.swift
//  MyToDoList
//
//  Created by 김시종 on 3/25/24.
//

import UIKit

protocol TodoCellDelegate: AnyObject {
    func didTapButton(_ cell: TodoCell, isSelected: Bool)
}


class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.addTarget(self, action: #selector(didTapButton(sender: )), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
// MARK: - 버튼이 눌렸을 때 실행되는 메서드
    @objc func didTapButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didTapButton(self, isSelected: sender.isSelected)
        
    }
}



