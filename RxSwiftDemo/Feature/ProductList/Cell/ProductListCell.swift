import UIKit
import SnapKit
import RxSwift
import Kingfisher

class ProductListCell: UITableViewCell {

    private var disposeBag = DisposeBag()

    private lazy var productImageView: UIImageView = {
        let view = UIImageView(frame: .zero)

        view.layer.cornerRadius = 5
        view.clipsToBounds = true

        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.font = .boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.primaryTextColor

        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textColor = UIColor.primaryTextColor

        return label
    }()

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    func config(item: Product) {
        productImageView.image = UIImage(named: item.images.first!)

        titleLabel.text = item.name

        priceLabel.text = item.price.getCurrencyString()
    }
}

extension ProductListCell {
    func initView() {
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceLabel)

        productImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            make.height.width.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top)
            make.leading.equalTo(productImageView.snp.trailing).offset(15)
            make.right.equalToSuperview().offset(15)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.right.equalToSuperview().offset(15)
            make.bottom.equalTo(productImageView.snp.bottom)
        }
    }
}

private extension Int {

    func getCurrencyString() -> String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency

        return formatter.string(from: NSNumber(value: self))!
    }

}
