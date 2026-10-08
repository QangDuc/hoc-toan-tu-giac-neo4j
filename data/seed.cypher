// Nạp dữ liệu học hình học phẳng lớp 8. Có thể chạy lại mà không tạo trùng node.
CREATE CONSTRAINT tugia_ten_unique IF NOT EXISTS
FOR (n:TuGiac) REQUIRE n.ten IS UNIQUE;
CREATE CONSTRAINT nguoichoi_ten_unique IF NOT EXISTS
FOR (n:NguoiChoi) REQUIRE n.ten IS UNIQUE;

UNWIND [
 {ten:'Tứ giác', moTa:'Đa giác có bốn cạnh, bốn đỉnh và bốn góc.', meo:'Đi một vòng bốn cạnh khép kín là nhớ tứ giác.'},
 {ten:'Hình thang', moTa:'Tứ giác có một cặp cạnh đối song song.', meo:'Nhớ một cặp cạnh đáy song song.'},
 {ten:'Hình thang cân', moTa:'Hình thang có hai góc kề một đáy bằng nhau.', meo:'Hai góc ở cùng một đáy bằng nhau.'},
 {ten:'Hình bình hành', moTa:'Tứ giác có các cặp cạnh đối song song.', meo:'Hai cặp cạnh đối cùng song song.'},
 {ten:'Hình chữ nhật', moTa:'Tứ giác có bốn góc vuông.', meo:'Bốn góc vuông, hai đường chéo bằng nhau.'},
 {ten:'Hình thoi', moTa:'Tứ giác có bốn cạnh bằng nhau.', meo:'Bốn cạnh bằng nhau là dấu hiệu dễ nhớ.'},
 {ten:'Hình vuông', moTa:'Tứ giác có bốn góc vuông và bốn cạnh bằng nhau.', meo:'Vừa là hình chữ nhật, vừa là hình thoi.'},
 {ten:'Hình diều', moTa:'Tứ giác có hai cặp cạnh kề bằng nhau.', meo:'Hai cặp cạnh bằng nhau nằm cạnh nhau.'}
] AS x
MERGE (t:TuGiac {ten:x.ten}) SET t.moTa=x.moTa, t.meo=x.meo;

UNWIND [
 ['Hình thang','Tứ giác'], ['Hình diều','Tứ giác'],
 ['Hình thang cân','Hình thang'], ['Hình bình hành','Hình thang'],
 ['Hình chữ nhật','Hình bình hành'], ['Hình thoi','Hình bình hành'],
 ['Hình vuông','Hình chữ nhật'], ['Hình vuông','Hình thoi']
] AS c
MATCH (con:TuGiac {ten:c[0]}), (cha:TuGiac {ten:c[1]})
MERGE (con)-[:LA_MOT]->(cha);

UNWIND [
 ['Tứ giác','Tổng số đo bốn góc bằng 360°','Có bốn cạnh','Có hai đường chéo'],
 ['Hình thang','Hai cạnh đáy song song','Hai góc kề một cạnh bên bù nhau','Đường trung bình song song với hai đáy'],
 ['Hình thang cân','Hai cạnh bên bằng nhau','Hai góc kề mỗi đáy bằng nhau','Hai đường chéo bằng nhau'],
 ['Hình bình hành','Các cạnh đối bằng nhau','Các góc đối bằng nhau','Hai đường chéo cắt nhau tại trung điểm mỗi đường'],
 ['Hình chữ nhật','Bốn góc vuông','Hai đường chéo bằng nhau','Hai đường chéo cắt nhau tại trung điểm mỗi đường'],
 ['Hình thoi','Bốn cạnh bằng nhau','Hai đường chéo vuông góc','Hai đường chéo là các đường phân giác của góc'],
 ['Hình vuông','Bốn cạnh bằng nhau','Bốn góc vuông','Hai đường chéo vuông góc và bằng nhau'],
 ['Hình diều','Hai cặp cạnh kề bằng nhau','Hai đường chéo vuông góc','Một đường chéo là đường trung trực của đường kia']
] AS row
MATCH (t:TuGiac {ten:row[0]})
MERGE (p:TinhChat {noiDung:row[1]}) MERGE (t)-[:CO_TINH_CHAT]->(p)
MERGE (p2:TinhChat {noiDung:row[2]}) MERGE (t)-[:CO_TINH_CHAT]->(p2)
MERGE (p3:TinhChat {noiDung:row[3]}) MERGE (t)-[:CO_TINH_CHAT]->(p3);

UNWIND [
 ['Tứ giác','Bốn cạnh tạo thành một hình kín','Tổng góc trong bằng 360°'],
 ['Hình thang','Tứ giác có một cặp cạnh đối song song','Hai góc kề một cạnh bên bù nhau'],
 ['Hình thang cân','Hình thang có hai góc kề một đáy bằng nhau','Hình thang có hai đường chéo bằng nhau'],
 ['Hình bình hành','Tứ giác có hai cặp cạnh đối song song','Tứ giác có hai cặp cạnh đối bằng nhau'],
 ['Hình chữ nhật','Hình bình hành có một góc vuông','Hình bình hành có hai đường chéo bằng nhau'],
 ['Hình thoi','Hình bình hành có hai cạnh kề bằng nhau','Hình bình hành có hai đường chéo vuông góc'],
 ['Hình vuông','Hình chữ nhật có hai cạnh kề bằng nhau','Hình thoi có một góc vuông'],
 ['Hình diều','Tứ giác có hai cặp cạnh kề bằng nhau','Hai cặp cạnh kề bằng nhau theo từng cặp']
] AS row
MATCH (t:TuGiac {ten:row[0]})
MERGE (d:DauHieu {noiDung:row[1]}) MERGE (t)-[:NHAN_BIET_BOI]->(d)
MERGE (d2:DauHieu {noiDung:row[2]}) MERGE (t)-[:NHAN_BIET_BOI]->(d2);

UNWIND [
 ['Tứ giác','Chu vi','P = a + b + c + d','a,b,c,d là độ dài bốn cạnh'],['Tứ giác','Diện tích','S = d1·d2·sin(α)/2','d1,d2 là hai đường chéo; α là góc giữa hai đường chéo'],
 ['Hình thang','Chu vi','P = a + b + c + d','a,b là hai đáy; c,d là hai cạnh bên'],['Hình thang','Diện tích','S = (a+b)·h/2','a,b là hai đáy; h là chiều cao'],
 ['Hình thang cân','Chu vi','P = a + b + 2c','a,b là hai đáy; c là cạnh bên'],['Hình thang cân','Diện tích','S = (a+b)·h/2','a,b là hai đáy; h là chiều cao'],
 ['Hình bình hành','Chu vi','P = 2(a+b)','a,b là độ dài hai cạnh kề'],['Hình bình hành','Diện tích','S = a·h','a là đáy; h là chiều cao tương ứng'],
 ['Hình chữ nhật','Chu vi','P = 2(a+b)','a,b là chiều dài và chiều rộng'],['Hình chữ nhật','Diện tích','S = a·b','a,b là chiều dài và chiều rộng'],
 ['Hình thoi','Chu vi','P = 4a','a là cạnh hình thoi'],['Hình thoi','Diện tích','S = d1·d2/2','d1,d2 là độ dài hai đường chéo'],
 ['Hình vuông','Chu vi','P = 4a','a là cạnh hình vuông'],['Hình vuông','Diện tích','S = a²','a là cạnh hình vuông'],
 ['Hình diều','Chu vi','P = 2(a+b)','a,b là độ dài hai cặp cạnh kề'],['Hình diều','Diện tích','S = d1·d2/2','d1,d2 là độ dài hai đường chéo']
] AS r
MATCH (t:TuGiac {ten:r[0]})
MERGE (f:CongThuc {ten:r[1], bieuThuc:r[2], bienSo:r[3]}) MERGE (t)-[:CO_CONG_THUC]->(f);

UNWIND [
 ['Hình thang','Tính chu vi hình thang có các cạnh 5, 8, 4, 4 cm.','21','Dễ'],
 ['Hình thang','Đáy lớn 10 cm, đáy bé 6 cm, chiều cao 3 cm. Tính diện tích.','24','Dễ'],
 ['Hình thang cân','Hai đáy dài 12 cm và 8 cm, chiều cao 5 cm. Tính diện tích.','50','Dễ'],
 ['Hình thang cân','Hai đáy 9 cm và 15 cm, hai cạnh bên 5 cm. Tính chu vi.','34','Trung bình'],
 ['Hình bình hành','Đáy 11 cm, chiều cao tương ứng 4 cm. Tính diện tích.','44','Dễ'],
 ['Hình bình hành','Hai cạnh kề dài 7 cm và 12 cm. Tính chu vi.','38','Dễ'],
 ['Hình chữ nhật','Chiều dài 9 cm, chiều rộng 4 cm. Tính diện tích.','36','Dễ'],
 ['Hình chữ nhật','Chu vi 30 cm, chiều dài 9 cm. Tính chiều rộng.','6','Trung bình'],
 ['Hình thoi','Hai đường chéo dài 10 cm và 6 cm. Tính diện tích.','30','Dễ'],
 ['Hình thoi','Cạnh hình thoi dài 8 cm. Tính chu vi.','32','Dễ'],
 ['Hình vuông','Cạnh hình vuông dài 7 cm. Tính diện tích.','49','Dễ'],
 ['Hình vuông','Diện tích hình vuông là 64 cm². Tính độ dài cạnh.','8','Trung bình'],
 ['Hình diều','Hai đường chéo dài 12 cm và 5 cm. Tính diện tích.','30','Dễ'],
 ['Hình diều','Hai cặp cạnh kề dài 6 cm và 9 cm. Tính chu vi.','30','Trung bình'],
 ['Tứ giác','Ba góc của tứ giác là 80°, 90°, 100°. Tính góc thứ tư.','90','Trung bình']
] AS r
MATCH (t:TuGiac {ten:r[0]})
MERGE (b:BaiTap {de:r[1]}) SET b.dapAn=r[2], b.mucDo=r[3]
MERGE (b)-[:THUOC_VE]->(t);

UNWIND [
 ['Tứ giác','Tổng số đo các góc trong của một tứ giác là bao nhiêu?',['180°','270°','360°','540°'],2],
 ['Tứ giác','Tứ giác có bao nhiêu cạnh?',['3','4','5','6'],1],
 ['Hình thang','Hình thang có cặp cạnh nào song song?',['Hai cạnh kề','Một cặp cạnh đối','Hai đường chéo','Không có cạnh nào'],1],
 ['Hình thang','Đường trung bình hình thang song song với cạnh nào?',['Cạnh bên','Hai đáy','Một đường chéo','Không cạnh nào'],1],
 ['Hình thang cân','Trong hình thang cân, hai đường chéo như thế nào?',['Vuông góc','Bằng nhau','Song song','Không cắt nhau'],1],
 ['Hình thang cân','Hai góc kề cùng một đáy của hình thang cân…',['Bằng nhau','Bù nhau luôn','Vuông','Khác nhau'],0],
 ['Hình bình hành','Trong hình bình hành, hai đường chéo…',['Bằng nhau','Vuông góc','Cắt nhau tại trung điểm mỗi đường','Song song'],2],
 ['Hình bình hành','Các cạnh đối của hình bình hành…',['Vuông góc','Bằng nhau','Không song song','Bằng nửa nhau'],1],
 ['Hình chữ nhật','Hình chữ nhật có bao nhiêu góc vuông?',['2','3','4','0'],2],
 ['Hình chữ nhật','Hai đường chéo hình chữ nhật…',['Bằng nhau','Vuông góc luôn','Song song','Không bằng nhau'],0],
 ['Hình thoi','Hình thoi có bao nhiêu cạnh bằng nhau?',['2','3','4','Không cạnh nào'],2],
 ['Hình thoi','Hai đường chéo hình thoi…',['Song song','Vuông góc','Bằng nhau luôn','Không cắt nhau'],1],
 ['Hình vuông','Hình vuông đồng thời là hình chữ nhật và hình gì?',['Hình thang cân','Hình thoi','Hình diều','Tam giác'],1],
 ['Hình vuông','Hình vuông có bao nhiêu góc vuông?',['1','2','3','4'],3],
 ['Hình diều','Hình diều có đặc điểm cạnh nào?',['Hai cặp cạnh đối bằng nhau','Hai cặp cạnh kề bằng nhau','Bốn cạnh bằng nhau luôn','Không cạnh nào bằng nhau'],1],
 ['Hình diều','Hai đường chéo hình diều vuông góc với nhau không?',['Có','Không bao giờ','Chỉ khi là hình chữ nhật','Chỉ khi là hình thang'],0]
] AS r
MATCH (t:TuGiac {ten:r[0]})
MERGE (q:CauHoi {noiDung:r[1]}) SET q.luaChon=r[2], q.dapAnDung=r[3]
MERGE (q)-[:THUOC_VE]->(t);
