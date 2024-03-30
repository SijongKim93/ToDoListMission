//
//  ViewController.swift
//  MyToDoList
//
//  Created by 김시종 on 3/25/24.
//

import UIKit

class ViewController: UIViewController {

    var todoArray: [Todo] = []
    var todoDataManager = DataManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        title = "ToDoList"
    }
    
// MARK: - Edit 버튼이 눌렸을 때 호출되는 메서드
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            editButton.title = "Edit"
            tableView.setEditing(false, animated: true)
        } else {
            editButton.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }
    
// MARK: - 버튼 누를 경우, 알럿 띄우고 텍스트필드 열어 새로운 셀 입력
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일을 추가해 주세요.", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "입력하세요"
        }
        
        let plusAction = UIAlertAction(title: "추가", style: .default) { [weak self] (_) in
            guard let textField = alert.textFields?.first,
                  let text = textField.text else { return }
            let newTodo = Todo(id: self?.todoArray.count ?? 0, title: text, isCompleted: false)
            self?.todoArray.append(newTodo)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(plusAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - 셀 삭제 버튼 눌렀을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}


// MARK: - DataSource , Delegate 함수 구현 (셀 불러오기 , 취소선 생성)

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
// MARK: - 셀 생성 재사용 반환 하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let todo = todoArray[indexPath.row]
        
// MARK: - 재사용 시 레이블 취소선 값 초기화 및 값 저장
        cell.cellLabel.attributedText = nil
        cell.cellLabel.text = todo.title
        cell.checkButton.isSelected = todo.isCompleted
        
// MARK: - 버튼의 선택 여부에 따라 취소선 설정 또는 제거
        if cell.checkButton.isSelected {
            let attributedText = todo.title.strikeThrough()
            cell.cellLabel.attributedText = attributedText
        } else {
            cell.cellLabel.attributedText = NSAttributedString(string: todo.title)
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

// MARK: - TodoCellDelegate 구현
extension ViewController: TodoCellDelegate {
    func didTapButton(_ cell: TodoCell, isSelected: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        //선택된 버튼의 상태를 변경하고 테이블 뷰 업데이트
        todoArray[indexPath.row].isCompleted = isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - String 확장하여 취소선 메서드 구현
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
