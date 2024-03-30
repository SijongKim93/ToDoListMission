//
//  DataManager.swift
//  MyToDoList
//
//  Created by 김시종 on 3/25/24.
//

import UIKit

class DataManager {
    var todoDataArray: [Todo] = []
    
    func makeTodoData() {
        todoDataArray = []
    }
    
    func getTodoData() -> [Todo] {
        return todoDataArray
    }
    
    
}
