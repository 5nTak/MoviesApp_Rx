//
//  VoteAverageView.swift
//  MoviesApp_Rx
//
//  Created by Tak on 8/7/24.
//

import UIKit
import SnapKit

final class VoteAverageView: UIView {

    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    // MARK: - Configurable properties

    private let backgroundLayer = CAShapeLayer()
    @IBInspectable private var backgroundLayerColor: UIColor = .lightGray {
        didSet {
            updateShapeLayerColors()
        }
    }

    private let loadedLayer = CAShapeLayer()
    @IBInspectable private var loadedLayerColor: UIColor = .systemBlue {
        didSet {
            updateShapeLayerColors()
        }
    }

    @IBInspectable private var layerLineWidth: CGFloat = 5.0 {
        didSet {
            setupShapeLayers()
        }
    }

    @IBInspectable private var layerStartAngle: CGFloat = 45.0 {
        didSet {
            setupShapeLayerPath(loadedLayer)
        }
    }

    var voteValue: Double? {
        didSet {
            updateVoteValue(voteValue)
        }
    }

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShapeLayerPath(backgroundLayer)
        setupShapeLayerPath(loadedLayer)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        isAccessibilityElement = true
        setupLabels()
        setupShapeLayers()
    }

    private func setupLabels() {
        addSubview(voteAverageLabel)
        voteAverageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupShapeLayers() {
        backgroundLayer.lineWidth = layerLineWidth
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.strokeColor = backgroundLayerColor.cgColor
        layer.addSublayer(backgroundLayer)

        loadedLayer.lineWidth = layerLineWidth
        loadedLayer.fillColor = nil
        loadedLayer.strokeEnd = 0
        loadedLayer.strokeColor = loadedLayerColor.cgColor
        layer.addSublayer(loadedLayer)

        updateVoteValue(voteValue)
    }

    private func setupShapeLayerPath(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = bounds
        let startAngle = degreesToRadians(layerStartAngle)
        let endAngle = degreesToRadians(layerStartAngle) + 2 * CGFloat.pi
        let center = voteAverageLabel.center
        let radius = bounds.width * 0.35
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true).cgPath
        shapeLayer.path = path
    }

    private func updateShapeLayerColors() {
        backgroundLayer.strokeColor = backgroundLayerColor.cgColor
        loadedLayer.strokeColor = loadedLayerColor.cgColor
    }

    private func updateVoteValue(_ voteValue: Double?) {
        guard let voteValue = voteValue, voteValue > 0.0 else {
            voteAverageLabel.text = "-"
            loadedLayer.strokeEnd = 0.0
            return
        }
        let toValue = voteValue / 10.0
        loadedLayer.strokeEnd = CGFloat(toValue)
        voteAverageLabel.text = String(format: "%.1f", voteValue)
        accessibilityLabel = String(format: "Rating of %.1f", voteValue)
    }

    private func degreesToRadians (_ value: CGFloat) -> CGFloat {
        let piDegrees: CGFloat = 180.0
        return (value * CGFloat.pi) / piDegrees
    }
}
