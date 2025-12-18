import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Lifecycle
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    private var presenter: MovieQuizPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
        statisticService = StatisticService()
        
        showLoadingIndicator()
        
        
    }
    
    func showNetworkError(message: String) {
        //        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    
    
    
    
    
    
    private var alertPresenter = AlertPresenter()
    
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func resetImageBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func show(quiz result: QuizResultsViewModel){
        
        let message = presenter.makeResultsMessage()
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let model = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText) { [weak self] in
                //используем слабую ссылку чтобы избежать retain cycle
                guard let self = self else { return }
                // разворачиваем слабую ссылку
                
                
                self.presenter.restartGame()
                
                
                
            }
        alertPresenter.show(in: self, model: model)
        
    }
    
}

