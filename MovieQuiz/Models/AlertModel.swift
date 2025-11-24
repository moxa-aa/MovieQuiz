//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Moxa on 21/11/25.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion : () -> Void
    
}
