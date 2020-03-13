//
//  ExerciseListCellType.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation
import UIKit

enum ExerciseListCellType {
    case execiseCell(exercise: Exercise)
    
    static func registerNibs(in tableView: UITableView) {
        tableView.registerNib(ExerciseCell.self)
    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        switch self {
        case .execiseCell(exercise: let exercise):
            return prepareExerciseCell(exercise,
                                       in: tableView,
                                       at: indexPath)
        }
    }
    
    private func prepareExerciseCell(_ exercice: Exercise, in tableView: UITableView, at indexPath: IndexPath) -> ExerciseCell {
        
        let cell: ExerciseCell = tableView.dequeueReusableCell(for: indexPath)
        cell.set(with: exercice)
        return cell
    }
}
