import Foundation
import UIKit

/// Ячейка привычки
class HabitCollectionViewCell: UICollectionViewCell {
    
    /// Лейбл с названием Привычки.
    private lazy var habitNameLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Privichka"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .green
        label.numberOfLines = 0
        return label
    }()
    
    /// Лейбл со временем выполнения для привычки.
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в 11:00"
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    /// Лейбл со счетчиком кол-ва выполнений привычки.
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Счетчик: 3"
        label.numberOfLines = 0
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    /// Кнопка выполнения привычки.
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }()
    
    /// Галочка, появляющаяся поверх кнопки выполнения привычки, в случае ее нажатия.
    private lazy var checkImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "checkmark")
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .white
        contentView.addSubview(timeLabel)
        contentView.addSubview(habitNameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(checkButton)
        contentView.addSubview(checkImage)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Создание Констрейнтов.
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            
            habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,  constant: -68),
            
            timeLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkButton.heightAnchor.constraint(equalToConstant: 36),
            checkButton.widthAnchor.constraint(equalToConstant: 36),
            
            checkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            checkImage.heightAnchor.constraint(equalToConstant: 25),
            checkImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    /// Функция настройки ячейки. Вызывается в HabitsViewController при настройке Сollection View.
    func setupCell(index: Int) {
        
        habitNameLabel.tag = index
        habitNameLabel.textColor = HabitsStore.shared.habits[index].color
        habitNameLabel.text = HabitsStore.shared.habits[index].name
        checkButton.layer.borderColor = HabitsStore.shared.habits[index].color.cgColor
        countLabel.text = "Счетчик: \(HabitsStore.shared.habits[index].trackDates.count)"
        timeLabel.text = HabitsStore.shared.habits[index].dateString
        
        if HabitsStore.shared.habits[index].isAlreadyTakenToday {
            checkButton.backgroundColor = UIColor(cgColor: HabitsStore.shared.habits[index].color.cgColor)
            checkImage.isHidden = false
        } else {
            checkButton.backgroundColor = nil
            checkImage.isHidden = true
        }
    }
    
    /// Функция проявления галочки, при нажатии на кнопку и отправка уведомления.
        @objc func clickButton () {
        
        let index = habitNameLabel.tag
        if  HabitsStore.shared.habits[index].isAlreadyTakenToday {
        } else {
            checkButton.backgroundColor = UIColor(cgColor: checkButton.layer.borderColor!)
            HabitsStore.shared.track(HabitsStore.shared.habits[index])
            countLabel.text = "Счетчик: \(HabitsStore.shared.habits[index].trackDates.count)"
            checkImage.isHidden = false
        }
            NotificationCenter.default.post(name: Notification.Name("reloadProgressCell"), object: nil)  // Отправляем уведомление, о необходимости обновления view.
    }
    
}
