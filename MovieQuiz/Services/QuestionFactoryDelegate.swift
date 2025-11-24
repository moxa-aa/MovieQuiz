//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Moxa on 20/11/25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
