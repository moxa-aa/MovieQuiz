import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        //        if questions[currentQuestionIndex].correctAnswer == true {
        //            showAnswerResult(isCorrect: true)
        //        } else {
        //            showAnswerResult(isCorrect: false)
        //        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        //        if questions[currentQuestionIndex].correctAnswer == false {
        //            showAnswerResult(isCorrect: false)
        //        } else {
        //            showAnswerResult(isCorrect: true)
        //        }
        
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        yesButton.layer.cornerRadius = 15
        //        yesButton.clipsToBounds = true
        //        noButton.layer.cornerRadius = 15
        //        noButton.clipsToBounds = true
        let currentQuestion = questions[currentQuestionIndex]
        let questionViewModel = convert(model: currentQuestion)
        show(quiz: questionViewModel)
        
        
    }
    
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
        
    }
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
        
    ]
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        
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
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.YpGreen.cgColor : UIColor.ypRed.cgColor
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
        
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // 1
            // идём в состояние "Результат квиза"
            let quizResult = QuizResultsViewModel(title: "Игра завершилась", text: "Ваш результат \(correctAnswers) / \(questions.count)", buttonText: "Начать заново")
            show(quiz: quizResult)
            
            
            
        } else { // 2
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
            // идём в состояние "Вопрос показан"
        }
    }
    
    private func show(quiz result: QuizResultsViewModel){
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        // добавляем в алерт кнопку
        alert.addAction(action)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
