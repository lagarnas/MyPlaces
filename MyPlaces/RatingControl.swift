//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Анастасия Лагарникова on 08.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    public var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: - Button Action
    @objc func ratingButtonTapped(_ button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        //calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: - Private Methods
    private func setupButtons() {
        
        ratingButtons.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        //Load button image
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                    in: bundle,
                                    compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<starCount{
            let button = UIButton()
             //Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: [.highlighted, .normal])
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
             
             //Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
             
             //Setup the button action
             button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
             
             //Add button in stackView
             addArrangedSubview(button)
            
            //Add the new button in rating array
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
