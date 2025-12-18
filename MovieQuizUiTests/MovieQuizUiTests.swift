//
//  MovieQuizUiTests.swift
//  MovieQuizUiTests
//
//  Created by Moxa on 12/12/25.
//

import XCTest

final class MovieQuizUiTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertAppearance() {

        // Эмулируем действие, которое вызывает алерт
        for _ in 1...10  {
            app.buttons["Yes"].tap()
            sleep(1)
        }


        let alert = app.alerts["Игра завершилась"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))

        // Проверяем заголовок
        XCTAssertEqual(alert.label, "Игра завершилась")

        // Проверяем кнопки
        XCTAssertTrue(alert.buttons["Начать заново"].exists)
    }
    
}
