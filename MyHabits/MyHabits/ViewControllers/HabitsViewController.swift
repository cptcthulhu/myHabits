import Foundation
import UIKit

/// Рутовый контроллер вкладки "Привычки".
class HabitsViewController: UIViewController {
    
    ///  Лэйаут СollectionView.
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        return layout
    }()
    
    /// СollectionView.
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: "ProgressBarCell")
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "Habit Cell")
        collectionView.backgroundColor = UIColor(named: "AlmostWhite")
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AlmostWhite")
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarCustomization()
        notificationCatchers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    /// Создание обзервера на уведомление о необходимости обновления CollectionView.
    private func notificationCatchers () {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addCell(notification:)),
                                               name: Notification.Name("addCell"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteCell(notification:)),
                                               name: Notification.Name("deleteCell"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadProgressCell(notification:)),
                                               name: Notification.Name("reloadProgressCell"),
                                               object: nil)
        
    }
    
    /// Cоздание Констрейнтов.
    private func setupConstraints (){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Настройка Navigation Bar.
    func navBarCustomization () {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor(named: "Purple")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "Сегодня"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.didTapButton))
        
    }
    
    /// Функция перехода на экран создания привычки при нажатии на "+" в Navigation Bar.
    @objc private func didTapButton() {
        let newAwesomeNavigationBar = UINavigationController(rootViewController: HabitViewController())
        newAwesomeNavigationBar.modalPresentationStyle = .fullScreen
        present(newAwesomeNavigationBar, animated: true)
        
    }
    
    /// Функции обновления Collection View.
    @objc private func addCell (notification: Notification) {
        print("adding Cell")
        let indexPath = IndexPath(item: HabitsStore.shared.habits.count, section: 0)
        let indexPathOfProgressCell = IndexPath(item: 0, section: 0)
        self.collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: [indexPath])
            self.collectionView.reloadItems(at: [indexPathOfProgressCell])
        }
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name("addCell"), object: nil)
    }
    
    @objc private func reloadProgressCell (notification: Notification){
        let indexPathOfProgressCell = IndexPath(item: 0, section: 0)
        self.collectionView.performBatchUpdates {
        self.collectionView.reloadItems(at: [indexPathOfProgressCell])
        }
    }
    
    @objc private func deleteCell (notification: Notification) {
        
        let indexPath = IndexPath(item: ((notification.object as! Int)+1), section: 0)
        print("delete \((notification.object as! Int)+1)")
        let indexPathOfProgressCell = IndexPath(item: 0, section: 0)
        self.collectionView.performBatchUpdates {
            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadItems(at: [indexPathOfProgressCell])
        }
        NotificationCenter.default.removeObserver(self, name:  NSNotification.Name("deleteCell"), object: nil)
    }
}

extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// Задание количества ячеек в CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        HabitsStore.shared.habits.count + 1
    }
    
    /// Размещение ячеек в CollectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item ==  0 {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ProgressBarCell", for: indexPath) as! ProgressCollectionViewCell
            cell.layer.cornerRadius = 6
            cell.setup()
            return cell
        } else {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Habit Cell", for: indexPath) as! HabitCollectionViewCell
            cell.layer.cornerRadius = 6
            cell.setupCell(index: (indexPath.item - 1))
            return cell
        }
    }
    
    /// Задаем размеры ячеек.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return  CGSize(width: view.frame.width-32 , height: 60)
        } else {
            return  CGSize(width: view.frame.width-32 , height: 130)
        }
    }
    
    /// Создание перехода по тапу на ячейку привычки на HabitDetailsViewController.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let vc = HabitDetailsViewController()
            vc.detailHabitIndex = indexPath.item - 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
