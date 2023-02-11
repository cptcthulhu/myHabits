import Foundation
import UIKit

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    var habitIndex: Int = 0 // Переменная, в которую передается индекс привычки, согласно которому настраивается экран.
    var calledForEditing = false // Произошел дли переход экран для настройки или для создания привычки.
    
    /// AlertController вызываемые при нажатии на кнопку удалить.
    let alertController = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку?", preferredStyle: .alert)
    
    ///  Заголовок "Название" , над полем ввода названия привычки
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Поле ввода названия привычки
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textField.textColor = UIColor(named: "Blue")
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    ///Заголовок "Цвет" над кнопкой выбора цвета
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// Кнопка, к которой привязан вызов ColorPicker'a, меняющая цвет, на выбранный в ColorPicker'е.
    private lazy var colorPicker: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(didTapColorPicker), for: .touchUpInside)
        return button
    }()
    
    /// Заголовок "Время" над полем выбора времени.
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// Первая, не изменяемая, часть фразы про выбор времени.
    private lazy var timeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в "
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    /// Вторая, изменяемая часть фразы, привязанная ко времени, выбранному в DatePicker'e.
    private lazy var timePickerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:00 PM"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "Purple")
        return label
    }()
    
    /// Создание и настройка DatePicker'а.
    private lazy var timePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(didSelect), for: .valueChanged)
        return picker
    }()
    
    /// Кнопка удаления привычки внизу экрана.
    private lazy var deleteHabbitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteHabbit), for: .touchUpInside)
        return button
    }()
    
    // Контейнеры для хранения названия, времени и цвета привычки.
    private var name: String = ""
    private var date: Date = Date()
    private var color: UIColor = .systemRed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupIfCalledForEditing()
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPicker)
        view.addSubview(timeLabel)
        view.addSubview(timeDescriptionLabel)
        view.addSubview(timePickerLabel)
        view.addSubview(timePicker)
        view.addSubview(deleteHabbitButton)
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarCustomization()
        
    }
    
    /// Настройка NavigationBar'a.
    func navBarCustomization () {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "Создать"
        /// Создаем левую кнопку NavigationBar'a и связываем с функцией удалением контроллером создания привычки
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissSelf))
        ///Создаем правую кнопку NavigationBar'a и связываем с функцием сохранения привычки
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveHabbit))
    }
    
    /// Констрейнты
    func addConstraints () {
        
        NSLayoutConstraint.activate([
            
            ///Заголовок "Название"
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            /// Поле ввода Названия привычки
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 20),
            
            /// Загловок "Цвет"
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            /// Кнопка выбора цвета
            colorPicker.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            colorPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorPicker.heightAnchor.constraint(equalToConstant: 30),
            colorPicker.widthAnchor.constraint(equalToConstant: 30),
            
            /// Заголовок "Время"
            timeLabel.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            /// Неизменяемая часть фразы про выбор времени
            timeDescriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            timeDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            /// Изменяемая чать, привязанная к DatePicker'y
            timePickerLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            timePickerLabel.leftAnchor.constraint(equalTo: timeDescriptionLabel.rightAnchor),
            
            ///DatePicker
            timePicker.topAnchor.constraint(equalTo: timeDescriptionLabel.bottomAnchor, constant: 16),
            timePicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         //   timePicker.widthAnchor.constraint(equalToConstant: 320),
        //    timePicker.heightAnchor.constraint(equalToConstant: 216),
            
            /// Кнопка удаления привычки внизу экрана.
            deleteHabbitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deleteHabbitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            deleteHabbitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            deleteHabbitButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    /// Функция настройки View, в случае если переход на контроллер произошел для настройки имеющейся привычки, а не создания новой.
    private func setupIfCalledForEditing () {
      
        if calledForEditing {
            nameLabel.textColor = HabitsStore.shared.habits[habitIndex].color
            nameLabel.text = HabitsStore.shared.habits[habitIndex].name
            colorPicker.backgroundColor = HabitsStore.shared.habits[habitIndex].color
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timePickerLabel.text = "\(dateFormatter.string(from: HabitsStore.shared.habits[habitIndex].date))"
            
            self.name = HabitsStore.shared.habits[habitIndex].name
            self.date = HabitsStore.shared.habits[habitIndex].date
            self.color = HabitsStore.shared.habits[habitIndex].color
            
            self.deleteHabbitButton.isHidden = false
        }
    }
    
    /// Функция, устанавливающая выбранное в DatePicker'e время, в качестве текста, изменяемой части загловка о выборе времени для привычки.
    @objc private func didSelect() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timePickerLabel.text = "\(dateFormatter.string(from: timePicker.date))"
        self.date = timePicker.date
    }
    
    /// Функция, привязанная к кнопке "Отменить" в NavigationBar'e, закрывающая контроллер создания привычки.
    @objc private func dismissSelf(){
        calledForEditing = false
        dismiss(animated: true, completion: nil)
    }
    
    /// Функция Вызывающая ColorPicker и сохраняющая последний выбранный цвет, при повторном вызове.
    @objc private func didTapColorPicker(){
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = self.colorPicker.backgroundColor!
        present(colorPicker, animated: true)
    }
    
    /// Сохрание текста из ТекстФилда в контейнер.
    @objc func statusTextChanged(_ textField: UITextField){
        if let i = textField.text {
            self.name = i
        }
    }
    
    /// Сохранение привычки и убирание контроллера.
    @objc private func saveHabbit() {
        
        if calledForEditing {
            HabitsStore.shared.habits[habitIndex].name = self.name
            HabitsStore.shared.habits[habitIndex].date = self.date
            HabitsStore.shared.habits[habitIndex].color = self.color
            print("\(self.name) 3")
            
        } else {
            let newHabit = Habit(name: self.name,
                                 date: self.date,
                                 color: self.color)
            
            let store = HabitsStore.shared
            store.habits.append(newHabit)
        }
        
        calledForEditing = false
        HabitsStore.shared.save()
        
        NotificationCenter.default.post(name: Notification.Name("addCell"), object: nil) // Отправка уведомления о необходимоти обновления CollectionView.
        NotificationCenter.default.post(name: Notification.Name("hideDetailView"), object: nil)// Отправка уведомления, о необходимости пропустить HabitDetailsViewController.
        dismiss(animated: true, completion: nil)
    }
    
    /// Функция изменения цвета кнопки вызова ColorPicker'a, соответственно выбранному цвету и сохрание выбранного цвета в контейнер.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorPicker.backgroundColor = color
        self.color = color
    }
    
    /// Удаление привычки и настройка AlertController, вызываемого при нажатии кнопки "Удалить Привычку".
    @objc func deleteHabbit () {
        alertController.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { _ in
        }))
        alertController.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { _ in
            HabitsStore.shared.habits.remove(at: self.habitIndex)
            NotificationCenter.default.post(name: Notification.Name("deleteCell"), object: self.habitIndex)
            NotificationCenter.default.post(name: Notification.Name("hideDetailView"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
