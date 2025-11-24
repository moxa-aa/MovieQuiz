import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }// 1
        let givenAnswer = true // 2
        
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        } // 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        //        yesButton.layer.cornerRadius = 15
        //        yesButton.clipsToBounds = true
        //        noButton.layer.cornerRadius = 15
        //        noButton.clipsToBounds = true
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
    }
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    private var alertPresenter = AlertPresenter()
    
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        
        return questionStep
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    
    
    private func showAnswerResult(isCorrect: Bool){
        
        if isCorrect {
            correctAnswers += 1
        }
        // красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YpGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            //используем слабую ссылку чтобы избежать retain cycle
            // код, который мы хотим вызвать через 1 секунду
            guard let self = self else { return }
            // разворачиваем слабую ссылку
            
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            
            self.showNextQuestionOrResults()
            
        }
        
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // 1
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
            let NumOfGames = statisticService.gamesCount
            
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(NumOfGames)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(accuracy)%
            
            """
            
            // идём в состояние "Результат квиза"
            let quizResult = QuizResultsViewModel(title: "Игра завершилась", text: text, buttonText: "Начать заново")
            show(quiz: quizResult)
            
            
            
        } else { // 2
            currentQuestionIndex += 1
            
            self.questionFactory.requestNextQuestion()
            
            // идём в состояние "Вопрос показан"
            
        } }
    
    private func show(quiz result: QuizResultsViewModel){
        
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                //используем слабую ссылку чтобы избежать retain cycle
                guard let self = self else { return }
                // разворачиваем слабую ссылку
                
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                questionFactory.requestNextQuestion()
                
                
            }
        alertPresenter.show(in: self, model: model)
        
    }
    
    
    
    /*
     Mock-данные
     
     
     Картинка: The Godfather
     Настоящий рейтинг: 9,2
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Dark Knight
     Настоящий рейтинг: 9
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Kill Bill
     Настоящий рейтинг: 8,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Avengers
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Deadpool
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Green Knight
     Настоящий рейтинг: 6,6
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Old
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: The Ice Age Adventures of Buck Wild
     Настоящий рейтинг: 4,3
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Tesla
     Настоящий рейтинг: 5,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Vivarium
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     */
}

