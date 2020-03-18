//
//  NewsTableViewCell.swift
//  News
//
//  Created by Maxim Zheleznyy on 3/10/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NewsTableViewCellIdentifier"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    private let rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(horizontalStackView)

        let padding: CGFloat = 16
        
        let horizontalStackConstraints = [
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
        ]
        
        let thumbnailViewConstraints = [
            thumbnailView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let constraintsArray = horizontalStackConstraints + thumbnailViewConstraints
        NSLayoutConstraint.activate(constraintsArray)

        horizontalStackView.addArrangedSubview(thumbnailView)

        rightVerticalStackView.addArrangedSubview(titleLabel)
        rightVerticalStackView.addArrangedSubview(contentLabel)
        horizontalStackView.addArrangedSubview(rightVerticalStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
