import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - QuestionFactoryDelegate
    
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
    // MARK: - IBOutlet
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Constant and Variables
    private var alertPresenter: AlertPresenter?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Private Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(viewController: self)
        showNextQuestionOrResults()
        imageView.layer.cornerRadius = 20
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.currentQuestionIndex += 1
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex >= questionsAmount {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            let bestGameDate = dateFormatter.string(from: statisticService.bestGame.date)
            
            let bestGameScore = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
            let bestGameText = "Рекорд: \(bestGameScore) (\(bestGameDate))"
            let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            \(bestGameText)
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%
            """
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.restartQuiz()
                }
            )
            alertPresenter?.present(alertModel: alertModel)
        } else {
            questionFactory.requestNextQuestion()
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    
}
