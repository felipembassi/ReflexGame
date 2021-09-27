//
//  ViewController.swift
//  ReflexGame
//
//  Created by Felipe Moreira Tarrio Bassi on 23/09/21.
//

import UIKit

class ReflexViewController: UIViewController {
    
    static let animationDuration: CGFloat = 0.3
    
    private lazy var collectionView: UICollectionView? = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.bounces = false
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private lazy var labelPoints: UILabel? = {
        var label = UILabel()
        label.text = String(format: LocalizableBundle.reflexGameScoreValue.localized, viewModel.score)
        label.font = .boldSystemFont(ofSize: .size(.small))
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelElapsedTime: UILabel? = {
        var label = UILabel()
        label.text = LocalizableBundle.reflexGameLabelElapsedTimeStartingValue.localized
        label.font = .boldSystemFont(ofSize: .size(.small))
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStart: UIButton? = {
        let buttonAction = UIAction { [weak self] _ in
            self?.buttonStart?.isEnabled = false
            self?.buttonStart?.backgroundColor = .gray
            self?.viewModel.startGame()
        }
        var button = UIButton(type: .custom, primaryAction: buttonAction)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = .size(.extraSmall)
        button.setTitle(LocalizableBundle.reflexGameButtonTittleStart.localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: .size(.small))
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackViewPhaseInfo: UIStackView? = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var viewModel: ReflexViewModelProtocol = ReflexViewModel()
    lazy var reflexDataSource = ReflexViewDataSource(viewModel: viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupSubviews()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupSubviews() {
        title = LocalizableBundle.reflexGameScreenTitle.localized
        view.backgroundColor = .lightGray
        setupStartButton()
        setupStackView()
        setupCollectionView()
    }
    
    private func setupStartButton() {
        guard let unwrappedButton = buttonStart else { return }
        view.addSubview(unwrappedButton)
        NSLayoutConstraint.activate([
            unwrappedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .spacing(.small)),
            unwrappedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.spacing(.small)),
            unwrappedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.spacing(.small)),
            unwrappedButton.heightAnchor.constraint(equalToConstant: .size(.large))
        ])
    }
    
    private func setupStackView() {
        guard let unwrappedStack = stackViewPhaseInfo, let unwrappedButton = buttonStart else { return }
        view.addSubview(unwrappedStack)
        NSLayoutConstraint.activate([
            unwrappedStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .spacing(.small)),
            unwrappedStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.spacing(.small)),
            unwrappedStack.bottomAnchor.constraint(equalTo: unwrappedButton.topAnchor, constant: -.spacing(.small))
        ])
        
        setupPointsLabelInsideStackView(unwrappedStack)
        setupElapsedTimeLabelInsideStackView(unwrappedStack)
    }
    
    private func setupPointsLabelInsideStackView(_ stackView: UIStackView) {
        guard let unwrappedLabel = labelPoints else { return }
        stackView.addArrangedSubview(unwrappedLabel)
    }
    
    private func setupElapsedTimeLabelInsideStackView(_ stackView: UIStackView) {
        guard let unwrappedLabel = labelElapsedTime else { return }
        stackView.addArrangedSubview(unwrappedLabel)
    }
    
    private func setupCollectionView() {
        guard let unwrappedCollectionView = collectionView, let stackView = stackViewPhaseInfo else { return }
        view.addSubview(unwrappedCollectionView)
        ReflexViewControllerCell.register(in: unwrappedCollectionView)
        NSLayoutConstraint.activate([
            unwrappedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .spacing(.small)),
            unwrappedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .spacing(.small)),
            unwrappedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.spacing(.small)),
            unwrappedCollectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -.spacing(.small))
        ])
        unwrappedCollectionView.dataSource = reflexDataSource
        unwrappedCollectionView.delegate = reflexDataSource
    }
    
    private func showGridFailure(_ completion: (() -> Void)? = nil) {
        collectionView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: Self.animationDuration) { [unowned self] in
            self.collectionView?.backgroundColor = .red
        } completion: { [unowned self] _ in
            self.collectionView?.backgroundColor = .black
            guard let unwrappedCompletion = completion else { return }
            unwrappedCompletion()
        }
    }
    
    private func showGridSuccess(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: Self.animationDuration) { [unowned self] in
            self.collectionView?.backgroundColor = .green
        } completion: { [unowned self] _ in
            self.collectionView?.backgroundColor = .black
            guard let unwrappedCompletion = completion else { return }
            unwrappedCompletion()
        }
    }
}

extension ReflexViewController: ReflexViewModelDelegate {
    func presentTimesUp(_ completion: @escaping () -> Void) {
        showGridFailure(completion)
    }
    
    func presentGameEnded() {
        collectionView?.backgroundColor = .red
        buttonStart?.isEnabled = true
        buttonStart?.backgroundColor = .darkGray
        collectionView?.isUserInteractionEnabled = false
        reflexDataSource.selectedIndex = nil
        collectionView?.reloadData()
    }
    
    func presentCpuSelection(at indexPath: IndexPath) {
        collectionView?.isUserInteractionEnabled = false
        collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
        reflexDataSource.selectedIndex = indexPath
    }
    
    func presentCorrectAnswer(_ completion: @escaping () -> Void) {
        showGridSuccess(completion)
    }
    
    func presentWrongAnswer(_ completion: @escaping () -> Void) {
        showGridFailure(completion)
    }
    
    func presentElapsedTime(_ timeInterval: String) {
        labelElapsedTime?.text = timeInterval
    }
    
    func presentCpuSelectionDidFinish() {
        if let unwrappedSelectedIndex = reflexDataSource.selectedIndex {
            collectionView?.deselectItem(at: unwrappedSelectedIndex, animated: true)
            collectionView?.isUserInteractionEnabled = true
        }
    }
    
    func presentScore(_ score: Int) {
        labelPoints?.text = String(format: LocalizableBundle.reflexGameScoreValue.localized, score)
    }
    
    func presentResetedGame() {
        collectionView?.backgroundColor = .black
    }
}
