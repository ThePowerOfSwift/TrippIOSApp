//
//  CategoryHeaderView.swift
//  Tripp
//
//  Created by Bharat Lal on 22/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
protocol CategoryHeaderProtocol: class {
    func itemDidTappedAt(_ index: Int);
}
class CategoryHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var bottomStrip: UIView!
    @IBOutlet weak var bottomStripXConstraint: NSLayoutConstraint!
    
    let nibName = "CategoryHeaderView"
    weak var delegate: CategoryHeaderProtocol?
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
       // contentView = view
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: Configuration
    func congigureViewWith(_ title: String, firstButtonTitle: String, secondButtonTile: String) {
        titleLabel.text = title
        firstButton.setTitle(firstButtonTitle, for: .normal)
        firstButton.setTitle(firstButtonTitle, for: .selected)
        secondButton.setTitle(secondButtonTile, for: .normal)
        secondButton.setTitle(secondButtonTile, for: .normal)
    }
    var isBackButtonHidden: Bool = false {
        didSet {
            backButton.isHidden = isBackButtonHidden
        }
    }
    //MARK: IBAction
    @IBAction func didTappeditem(_ sender: UIButton) {
        firstButton.isSelected = false
        secondButton.isSelected = false
        sender.isSelected = true
        animateBottomViewTo(sender.tag)
        delegate?.itemDidTappedAt(sender.tag)
    }
    @IBAction func backAction(_ sender: UIButton) {
        if let vc = self.parentViewController {
            vc.navigationController?.popViewController(animated: true)
        }
    }
    //MARK: Helper / private
    private func animateBottomViewTo(_ tag: Int) {
        var x = CGFloat(0.0)
        if tag == 2 {
            x = self.bounds.size.width/2.0
        }
        self.layoutIfNeeded()
        UIView.animate(withDuration: Double(0.3), animations: {
            self.bottomStripXConstraint.constant = x
            self.layoutIfNeeded()
        })
    }

}
