//
//  Button.swift
//  JSPuppet
//
//  Created by Chris on 23/11/2022.
//

import UIKit

class Button: UIButton {
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap() {
        onTap?()
    }
        
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1
        }
    }
}
