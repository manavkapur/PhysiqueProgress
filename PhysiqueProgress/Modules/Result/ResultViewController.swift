//
//  Untitled.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//
//
//  ResultViewController.swift
//  PhysiqueProgress
//

import UIKit

final class ResultViewController: UIViewController {

    private let viewModel: ResultViewModel

    // MARK: UI

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    private let heroView = ResultHeroView()
    private let breakdownView = ResultBreakdownView()
    private let postureView = ResultPostureView()
    private let insightView = ResultInsightView()
    private let actionView = ResultActionView()

    // MARK: Init

    init(viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    // MARK: Life

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.axis = .vertical
        stack.spacing = 18

        view.addSubview(scrollView)
        scrollView.addSubview(stack)

        [heroView, breakdownView, postureView, insightView, actionView].forEach {
            stack.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func bind() {
        heroView.configure(with: viewModel.hero)
        breakdownView.configure(with: viewModel.breakdown)
        postureView.configure(with: viewModel.posture)
        insightView.configure(with: viewModel.insight)
        actionView.configure()

        actionView.onProgress = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

