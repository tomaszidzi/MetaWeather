//
//
//  ForecastView.swift
//
//  Created by Tomasz Idzi on 05/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import UIKit

class ForecastView: UIView {

    // MARK: - Properties
   
    var viewModel: ViewModel? {
        didSet {
            update()
        }
    }
    
    var errorViewModel: ErrorViewModel? {
        didSet {
            update()
        }
    }
    
    // MARK: - UI Properties
   
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ cityLabel,
                                                        weatherDescriptionLabel,
                                                        tempLabel,
                                                        tempMinMaxLabel,
                                                        iconImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    let  cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let  weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let tempMinMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) isn't supported")
    }
    
    // MARK: - Configure methods
    
    private func configureUI() {
        
        // view
        addSubview(containerView)
        
        // titleLabel
        containerView.addSubview(contentStackView)
        
        // activityIndicator
        containerView.addSubview(activityIndicatorView)
    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: 0),
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func update() {
        if let model = viewModel  {
            cityLabel.text = model.cityName
            weatherDescriptionLabel.text = model.weatherDescription
            tempLabel.text = model.temp
            tempMinMaxLabel.text = model.minMaxTemp
            
            WeatherManager(session: URLSession.shared).getWeatherImage(model.weatherCode) { image in
                self.iconImageView.image = image
            }
        } else if let errorModel = errorViewModel {
            cityLabel.text = errorModel.error
            weatherDescriptionLabel.text = ""
            tempLabel.text = ""
            tempMinMaxLabel.text = ""
            iconImageView.image = nil
        }
    }
    
    // MARK: - Public methods
    
    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
