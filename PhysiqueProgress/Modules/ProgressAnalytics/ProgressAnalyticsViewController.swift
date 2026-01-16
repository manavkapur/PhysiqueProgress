//
//  ProgressAnalyticsViewController.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 16/01/26.
//
import UIKit

final class ProgressAnalyticsViewController: UIViewController {

    private let viewModel: ProgressAnalyticsViewModel

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let coverageControl = UISegmentedControl(items: ["Overall", "Full", "Upper"])
    private let rangeControl = UISegmentedControl(items: ["7D", "30D", "90D", "All"])

    private let heroView = AnalyticsHeroView()
    private let chartView = LineChartView()

    private let metricStack = UIStackView()
    private let vtaperCard = MetricCardView(title: "V-Taper", unit: "")
    private let fatCard = MetricCardView(title: "Fat Index", unit: "")
    private let torsoCard = MetricCardView(title: "Torso", unit: "")
    private let postureCard = MetricCardView(title: "Posture", unit: "")

    private let insightCard = InsightCardView()

    // MARK: - Init

    init(viewModel: ProgressAnalyticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progress Analytics"
        view.backgroundColor = .systemBackground

        setupUI()
        setupLayout()
        setupActions()

        reloadAll()
    }

    // MARK: - Setup

    private func setupUI() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        coverageControl.selectedSegmentIndex = 0
        rangeControl.selectedSegmentIndex = 1

        metricStack.axis = .vertical
        metricStack.spacing = 12
        metricStack.translatesAutoresizingMaskIntoConstraints = false

        let row1 = UIStackView(arrangedSubviews: [vtaperCard, fatCard])
        let row2 = UIStackView(arrangedSubviews: [torsoCard, postureCard])

        [row1, row2].forEach {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }

        metricStack.addArrangedSubview(row1)
        metricStack.addArrangedSubview(row2)

        chartView.translatesAutoresizingMaskIntoConstraints = false
        heroView.translatesAutoresizingMaskIntoConstraints = false
        insightCard.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            coverageControl,
            rangeControl,
            heroView,
            chartView,
            metricStack,
            insightCard
        ].forEach { contentView.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    private func setupLayout() {

        
        let bottom = insightCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        bottom.priority = .defaultHigh
        bottom.isActive = true
        
        let chartHeight = chartView.heightAnchor.constraint(equalToConstant: 240)
        chartHeight.priority = .required
        chartHeight.isActive = true
        
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            coverageControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            rangeControl.topAnchor.constraint(equalTo: coverageControl.bottomAnchor, constant: 10),
            rangeControl.leadingAnchor.constraint(equalTo: coverageControl.leadingAnchor),
            rangeControl.trailingAnchor.constraint(equalTo: coverageControl.trailingAnchor),

            heroView.topAnchor.constraint(equalTo: rangeControl.bottomAnchor, constant: 20),
            heroView.leadingAnchor.constraint(equalTo: coverageControl.leadingAnchor),
            heroView.trailingAnchor.constraint(equalTo: coverageControl.trailingAnchor),
            heroView.heightAnchor.constraint(equalToConstant: 180),

            chartView.topAnchor.constraint(equalTo: heroView.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: heroView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: heroView.trailingAnchor),

            metricStack.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 36),
            metricStack.leadingAnchor.constraint(equalTo: heroView.leadingAnchor),
            metricStack.trailingAnchor.constraint(equalTo: heroView.trailingAnchor),

            insightCard.topAnchor.constraint(equalTo: metricStack.bottomAnchor, constant: 20),
            insightCard.leadingAnchor.constraint(equalTo: heroView.leadingAnchor),
            insightCard.trailingAnchor.constraint(equalTo: heroView.trailingAnchor),
        ])
    }

    private func setupActions() {
        coverageControl.addTarget(self, action: #selector(coverageChanged), for: .valueChanged)
        rangeControl.addTarget(self, action: #selector(rangeChanged), for: .valueChanged)
    }

    // MARK: - Reload

    private func reloadAll() {

        heroView.configure(
            score: viewModel.heroScore(),
            grade: viewModel.heroGrade().rawValue,
            delta: viewModel.heroDelta(),
            subtitle: viewModel.heroSubtitle()
        )

        chartView.values = viewModel.physiqueSeries()

        vtaperCard.set(value: viewModel.latestVtaper())
        fatCard.set(value: viewModel.latestFatIndex())
        torsoCard.set(value: viewModel.latestTorso())
        postureCard.set(value: viewModel.latestPosture())

        insightCard.set(text: viewModel.insightText())
    }

    // MARK: - Actions

    @objc private func coverageChanged() {
        switch coverageControl.selectedSegmentIndex {
        case 1: viewModel.setCoverage(.full)
        case 2: viewModel.setCoverage(.upper)
        default: viewModel.setCoverage(.overall)
        }
        reloadAll()
    }

    @objc private func rangeChanged() {
        switch rangeControl.selectedSegmentIndex {
        case 0: viewModel.setRange(.days7)
        case 1: viewModel.setRange(.days30)
        case 2: viewModel.setRange(.days90)
        default: viewModel.setRange(.all)
        }
        reloadAll()
    }
}
