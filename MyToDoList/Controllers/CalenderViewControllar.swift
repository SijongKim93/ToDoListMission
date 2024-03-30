//
//  CalenderViewController.swift
//  MyToDoList
//
//  Created by 김시종 on 3/28/24.
//

import UIKit

class CalenderViewControllar: UIViewController {
    
    var todoArray: [Todo] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoCell" {
            if let destinationVC = segue.destination as? CalenderViewControllar {
                // todoArray를 CalenderViewController에 전달합니다.
                destinationVC.todoArray = self.todoArray
            }
        }
    }
    
// MARK: - 코드베이스로 캘린더 호출
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var selectedDate: DateComponents? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
    }

// MARK: - 캘린더 오토레이아웃
    fileprivate func applyConstraints() {
        view.addSubview(dateView)
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
    }

// MARK: - 캘린더 델리게이트 선언
    fileprivate func setCalendar() {
        dateView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
}

// MARK: - 캘린더 뷰 컨트롤러 델리게이트 확장 ( 단일 날짜 선택에 대한 변경 사항을 처리 )
extension CalenderViewControllar: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "🐶"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
            selectedDate = dateComponents
            reloadDateView(date: Calendar.current.date(from: dateComponents!))
        }
    
}
