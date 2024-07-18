import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        
        return slider
    }()
    
    let minLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Min: 18"
        
        return label
    }()
    
    let maxLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Max: 19"
        
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            .init(width: 80, height: 0)
        }
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareOverallStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func prepareOverallStackView() {
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider]),
        ])
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.distribution = .fillEqually
        let padding: CGFloat = 16
        overallStackView.spacing = padding
        NSLayoutConstraint.activate([
            overallStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            overallStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            overallStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            overallStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
}
