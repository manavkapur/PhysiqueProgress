//
//  HistoryViewController.swift
//  PhysiqueProgress
//

import UIKit

final class HistoryViewController: UIViewController {

    private let viewModel = HistoryViewModel()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progress History"
        view.backgroundColor = AppColors.background
        setupCollectionView()
        loadData()
    }

    private func loadData() {
        viewModel.loadImages()
        collectionView.reloadData()
    }

    private func setupCollectionView() {

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        collectionView.dataSource = self

        collectionView.register(
            HistoryCardCell.self,
            forCellWithReuseIdentifier: HistoryCardCell.reuseId
        )

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )

        item.contentInsets = .init(top: 6, leading: 6, bottom: 6, trailing: 6)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.72)
            ),
            subitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 10, bottom: 20, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data Source

extension HistoryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryCardCell.reuseId,
            for: indexPath
        ) as! HistoryCardCell

        let model = viewModel.item(at: indexPath.item)
        cell.configure(item: model)

        return cell
    }
}
