# Product backlog – Ứng dụng học chủ đề Tứ giác

Thang ưu tiên: High / Medium / Low. Story point ước lượng theo độ phức tạp tương đối. Kế hoạch gồm hai sprint; A phụ trách cơ sở dữ liệu và tài liệu, B phụ trách ứng dụng và hướng dẫn sử dụng.

| ID | User Story | Tiêu chí chấp nhận | Ưu tiên | SP | Sprint | Người phụ trách |
|---|---|---|---|---:|---|---|
| PB-01 | Là nhóm phát triển, tôi muốn khởi tạo cấu hình Neo4j để ứng dụng kết nối an toàn. | Thư viện được khai báo; cấu hình đọc từ biến môi trường; `.env` được bỏ qua bởi Git. | High | 2 | 1 | A |
| PB-02 | Là học sinh, tôi muốn xem danh sách tứ giác để chọn hình cần ôn. | Hiển thị tên và mô tả của tám loại hình từ Neo4j. | High | 2 | 1 | B |
| PB-03 | Là học sinh, tôi muốn xem chi tiết hình cùng mẹo ghi nhớ để nắm kiến thức nhanh. | Có mô tả, mẹo, tính chất, dấu hiệu và công thức khi dữ liệu tồn tại. | High | 3 | 1 | A+B |
| PB-04 | Là học sinh, tôi muốn xem sơ đồ phân cấp để hiểu quan hệ giữa các hình. | Đồ thị hiển thị đúng các cạnh `LA_MOT` đã nạp. | Medium | 3 | 1 | B |
| PB-05 | Là học sinh, tôi muốn tìm theo từ khóa để tra cứu nhanh một nội dung. | Kết quả tìm trong tên/mô tả, tính chất và dấu hiệu; từ khóa được truyền an toàn. | Medium | 2 | 1 | A+B |
| PB-06 | Là học sinh, tôi muốn nhập số đo để tính chu vi hoặc diện tích. | Chọn công thức phù hợp, nhập biến số và xem kết quả; dữ liệu nhập không làm lỗi ứng dụng. | Medium | 3 | 1 | B |
| PB-07 | Là học sinh, tôi muốn luyện bài theo hình và mức độ để tự kiểm tra. | Lọc được bài; hiển thị đề và so sánh đáp án ngắn/số với đáp án lưu. | High | 3 | 2 | A+B |
| PB-08 | Là học sinh, tôi muốn làm quiz trắc nghiệm để ôn tập qua câu hỏi ngẫu nhiên. | Lấy số câu yêu cầu, mỗi câu có bốn lựa chọn và chỉ số đáp án đúng hợp lệ. | High | 3 | 2 | A+B |
| PB-09 | Là người chơi, tôi muốn nhận điểm cho câu đúng để có động lực học. | Tên được MERGE duy nhất; câu đúng cộng 10 điểm; lưu kết quả và thời điểm. | Medium | 3 | 2 | A |
| PB-10 | Là học sinh, tôi muốn xem bảng xếp hạng để theo dõi thành tích. | Danh sách giới hạn số dòng, sắp xếp tổng điểm giảm dần. | Low | 2 | 2 | A+B |
| PB-11 | Là giáo viên, tôi muốn tạo bài tập để bổ sung nội dung luyện tập. | Bài tập lưu đề, đáp án, mức độ và liên kết đến hình hợp lệ. | Medium | 2 | 2 | A+B |
| PB-12 | Là giáo viên, tôi muốn sửa hoặc xóa bài tập để duy trì nội dung chính xác. | Cập nhật/xóa theo ID; hàm trả trạng thái thành công/thất bại. | Medium | 2 | 2 | A+B |
| PB-13 | Là giáo viên, tôi muốn thêm, sửa và xóa tính chất để cập nhật nội dung học. | CRUD tính chất gắn đúng hình; thao tác trả ID hoặc trạng thái tương ứng. | Medium | 3 | 2 | A+B |
| PB-14 | Là nhóm phát triển, tôi muốn nạp dữ liệu mẫu để có nội dung kiểm thử ban đầu. | Có tám hình, phân cấp, kiến thức, công thức, 10–15 bài tập và 15–20 câu quiz. | High | 5 | 1 | A |
| PB-15 | Là nhóm phát triển, tôi muốn có đặc tả và hướng dẫn kỹ thuật để phối hợp triển khai. | Đặc tả gồm yêu cầu, sơ đồ, truy vấn mẫu và lý do chọn Neo4j; tài liệu thành viên B được tạo riêng. | Medium | 3 | 2 | A+B |
| PB-16 | Là nhóm phát triển, tôi muốn rà soát hợp đồng hàm và dữ liệu để bàn giao nhất quán. | Chữ ký hàm đúng hợp đồng; seed có thể chạy lại; kiểm tra kết nối được ghi nhận rõ. | High | 3 | 2 | A+B |
