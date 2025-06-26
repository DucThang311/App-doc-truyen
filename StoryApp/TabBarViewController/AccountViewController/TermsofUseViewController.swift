//
//  TermsofUseViewController.swift
//  StoryReadingApp
//
//  Created by Mạc Đức Thắng on 10/6/25.
//

import UIKit

class TermsofUseViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollView()
        setupContent()
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        scrollView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupContent() {
        contentLabel.text = """



ĐIỀU KHOẢN SỬ DỤNG
Khi đã sử dụng ứng dụng, nghĩa là Khách hàng đã đọc, hiểu, chấp nhận và tuân thủ những điều được quy định trong Điều khoản sử dụng của chúng tôi. Trường hợp Khách hàng không đồng ý với bất kỳ thỏa thuận nào trong điều khoản này, vui lòng không sử dụng dịch vụ của Comicola.

Sự đồng ý với các điều khoản dịch vụ.
Bằng cách sử dụng các dịch vụ được cung cấp bởi ứng dụng “Comi” (gọi chung là “Dịch vụ”), Khách hàng đồng ý với các điều khoản và điều kiện của Điều khoản Dịch vụ của chúng tôi.
Chúng tôi sẽ cố gắng thông báo cho Khách hàng khi có những thay đổi lớn đối với các Điều khoản Dịch vụ, nhưng Khách hàng nên xem lại định kỳ phiên bản cập nhật mới nhất. Comicola có quyền bổ sung, sửa đổi nội dung Điều khoản dịch vụ vào bất kỳ thời điểm nào mà không cần phải thông báo trước, và Khách hàng phải có trách nhiệm thường xuyên theo dõi các quy định chung trên nền tảng của Comicola để nhận biết được những thay đổi này. Việc Khách hàng tiếp tục sử dụng dịch vụ của Comicola sau khi Comicola cập nhật bổ sung các điều khoản và quy định chứng tỏ rằng “Khách hàng đã đọc và đồng ý tuân theo những sửa đổi trên”.
Nếu bất kỳ điều khoản nào của Điều khoản dịch vụ này bị vô hiệu hoá bởi quyết định của cơ quan có thẩm quyền, thì sự vô hiệu lực của điều khoản đó sẽ không ảnh hưởng tới hiệu lực của các điều khoản còn lại.
Nếu Khách hàng thay mặt cho doanh nghiệp sử dụng Dịch vụ của chúng tôi thì doanh nghiệp đó cũng sẽ chấp nhận các điều khoản này. Doanh nghiệp đó sẽ phải chịu trách nhiệm và bồi thường cho Comicola và các đại lý, nhân viên của Comicola từ bất kỳ khiếu nại, kiện tụng hoặc hành động nào phát sinh hoặc liên quan đến việc sử dụng Dịch vụ hoặc vi phạm các điều khoản này, bao gồm mọi trách nhiệm pháp lý hoặc chi phí phát sinh từ khiếu nại, thua lỗ, thiệt hại, bản án, chi phí kiện tụng và phí luật sư,…
Khả năng chấp nhận điều khoản dịch vụ.
“Comi” chỉ dành cho những Khách hàng từ 13 tuổi trở lên. Nếu dưới 13 tuổi, Khách hàng phải nhận được sự đồng ý của người giám hộ cho phép sử dụng Dịch vụ.
Khách hàng phải xác nhận rằng Khách hàng có đủ thẩm quyền tham gia vào các điều khoản, điều kiện, nghĩa vụ, xác nhận, đại diện, bảo đảm và tuân thủ được quy định trong Điều khoản Dịch vụ này và tuân thủ theo Điều khoản Dịch vụ này.
Dịch vụ.
Các Điều khoản Dịch vụ này áp dụng cho tất cả người dùng Dịch vụ của “Comi”. Dịch vụ bao gồm tất cả các khía cạnh của bất kỳ sản phẩm “Comi” nào.
Dịch vụ có thể chứa liên kết đến các trang web của bên thứ ba không thuộc quyền sở hữu hoặc kiểm soát của “Comicola”. Comicola không kiểm soát được và không chịu trách nhiệm về nội dung, chính sách bảo mật hoặc thực tiễn của bất kỳ trang web bên thứ ba nào. Ngoài ra, Comicola sẽ không thể kiểm duyệt hoặc chỉnh sửa nội dung của bất kỳ trang web của bên thứ ba nào. Bằng cách sử dụng Dịch vụ, Khách hàng rõ ràng giảm bớt Comicola khỏi bất kỳ và tất cả trách nhiệm pháp lý phát sinh từ việc Khách hàng sử dụng bất kỳ trang web của bên thứ ba nào.
Theo đó, chúng tôi khuyến khích Khách hàng nhận thức được rõ khi rời khỏi Comi và đọc các điều khoản, điều kiện cũng như các chính sách khác của các trang web khác mà Khách hàng truy cập.
Các hành vi bị nghiêm cấm.
Trong quá trình sử dụng dịch vụ “Comi”, Khách hàng không được thực hiện các hành vi sau:

Chống lại Nhà nước Cộng hòa xã hội chủ nghĩa Việt Nam; gây phương hại đến an ninh quốc gia, trật tự an toàn xã hội; phá hoại khối đại đoàn kết dân tộc.
Tuyên tuyên truyền chiến tranh, khủng bố; gây hận thù, mâu thuẫn giữa các dân tộc, sắc tộc, tôn giáo; tuyên truyền, kích động bạo lực, dâm ô, đồi trụy, tội ác, tệ nạn xã hội, mê tín dị đoan, phá hoại thuần phong, mỹ tục của dân tộc.
Tiết lộ bí mật nhà nước, bí mật quân sự, an ninh, kinh tế, đối ngoại và những bí mật khác do pháp luật quy định.
Đưa thông tin xuyên tạc, vu khống, xúc phạm uy tín của tổ chức, danh dự và nhân phẩm của cá nhân.
Xúc phạm, nhạo báng người khác dưới bất kỳ hình thức nào (nhạo báng, lăng mạ, chê bai, kỳ thị tôn giáo, giới tính, sắc tộc, gây hiềm khích lẫn nhau…)
Quảng cáo, tuyên truyền, mua bán hàng hóa, dịch vụ bị cấm; truyền bá tác phẩm báo chí, văn học, nghệ thuật, xuất bản phẩm bị cấm.
Giả mạo tổ chức, cá nhân và phát tán thông tin giả mạo, thông tin sai sự thật xâm hại đến quyền và lợi ích hợp pháp của tổ chức, cá nhân.
Cản trở trái pháp luật việc cung cấp và truy cập thông tin hợp pháp, việc cung cấp và sử dụng các dịch vụ hợp pháp trên Internet của tổ chức, cá nhân.
Cản trở trái pháp luật hoạt động của hệ thống máy chủ tên miền quốc gia Việt Nam “.vn”, hoạt động hợp pháp của hệ thống thiết bị cung cấp dịch vụ Internet và thông tin trên mạng.
Sử dụng trái phép mật khẩu, khóa mật mã của tổ chức, cá nhân; thông tin riêng, thông tin cá nhân và tài nguyên Internet.
Tạo đường dẫn trái phép đối với tên miền hợp pháp của tổ chức, cá nhân; tạo, cài đặt, phát tán phần mềm độc hại, vi-rút máy tính; xâm nhập trái phép, chiếm quyền điều khiển hệ thống thông tin, tạo lập công cụ tấn công trên Internet.
Có hành vi gian dối, cung cấp thông tin sai sự thật trong quá trình sử dụng dịch vụ hoặc thực hiện các hành vi vi phạm quy định của pháp luật.
Chuyển nhượng, bán hoặc mua quyền của tư cách thành viên khác trả tiền cho bên thứ ba bất hợp pháp.
Tài khoản của người dùng Comi. 
Để sử dụng Dịch vụ của “Comi”, Khách hàng sẽ phải tạo tài khoản người dùng “Comi”. Thông tin về tài khoản của Khách hàng phải được cung cấp đầy đủ, chính xác và cập nhật mới nhất. 
Khách hàng vui lòng giữ bí mật mật khẩu và không tiết lộ cho bất kì ai thông tin mật khẩu của mình.
Khách hàng sẽ phải chịu trách nhiệm cho tất cả mọi việc sử dụng Dịch vụ từ tài khoản của Khách hàng.
Khách hàng phải thông báo cho Comicola ngay lập tức về mọi vi phạm bảo mật hoặc việc sử dụng trái phép tài khoản của Khách hàng.
Comicola luôn cố gắng bảo vệ thông tin Khách hàng bằng những nỗ lực cao nhất. Tuy nhiên, chúng tôi hiểu rằng Khách hàng sẽ chịu toàn bộ tổn thất tương đương với giá trị giao dịch, hành động sử dụng tài khoản không có sự ủy quyền cam kết với Comicola.
"""
    }
}



