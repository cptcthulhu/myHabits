import UIKit

/// Рутовый Экран для вкладки "Информация".
class InfoViewController: UIViewController {
    
    /// Переменная для текста на экране.
    private let infoText : String = """
    Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:

    1. Провести 1 день без обращения
    к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.

    2. Выдержать 2 дня в прежнем состоянии самоконтроля.

    3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.

    4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.

    5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.

    6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.
    """
    
    /// ScrollView.
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    ///  Лейбл Заголовка.
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычка за 21 день"
        return label
    }()
    
    /// Лейбл содержащий текст для экрана.
    private lazy var text: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel.text = infoText
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AlmostWhite")
        view.addSubview(scrollView)
        scrollView.addSubview(label)
        scrollView.addSubview(text)
        addConstraints()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarCustomization()
    }
    
    /// Cоздание Констрейнтов.
    private func addConstraints () {
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            text.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            text.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
   
    /// Настройка NavigationBar'a.
    func navBarCustomization () {
        // self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "Информация"
    }
}
