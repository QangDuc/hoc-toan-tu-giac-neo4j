"""Các hàm truy cập Neo4j cho ứng dụng học Toán hình học."""

import os
from typing import Any

from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()


def _driver():
    """Tạo driver từ cấu hình môi trường; không chứa thông tin đăng nhập trong mã."""
    uri = os.getenv("NEO4J_URI")
    user = os.getenv("NEO4J_USER")
    password = os.getenv("NEO4J_PASSWORD")
    if not all((uri, user, password)):
        raise RuntimeError("Thiếu NEO4J_URI, NEO4J_USER hoặc NEO4J_PASSWORD trong .env")
    return GraphDatabase.driver(uri, auth=(user, password))


def _read(query: str, **params: Any) -> list[dict]:
    """Chạy truy vấn đọc có tham số và trả các bản ghi dạng từ điển."""
    with _driver() as driver:
        with driver.session() as session:
            return [record.data() for record in session.run(query, **params)]


def _write(query: str, **params: Any) -> list[dict]:
    """Chạy truy vấn ghi có tham số trong transaction và trả các bản ghi."""
    with _driver() as driver:
        with driver.session() as session:
            return session.execute_write(
                lambda tx: [record.data() for record in tx.run(query, **params)]
            )


def ping() -> bool:
    """Kiểm tra cấu hình và khả năng kết nối tới Neo4j."""
    try:
        with _driver() as driver:
            driver.verify_connectivity()
        return True
    except Exception:
        return False


def get_all_tugiac() -> list[dict]:
    """Lấy danh sách tên và mô tả các loại tứ giác."""
    return _read("MATCH (t:TuGiac) RETURN t.ten AS ten, t.moTa AS moTa ORDER BY ten")


def get_tugiac_detail(ten: str) -> dict:
    """Lấy mô tả, mẹo, tính chất, dấu hiệu và công thức của một loại tứ giác."""
    rows = _read(
        """MATCH (t:TuGiac {ten:$ten})
        OPTIONAL MATCH (t)-[:CO_TINH_CHAT]->(p:TinhChat)
        WITH t, collect(DISTINCT p.noiDung) AS tinhChat
        OPTIONAL MATCH (t)-[:NHAN_BIET_BOI]->(d:DauHieu)
        WITH t, tinhChat, collect(DISTINCT d.noiDung) AS dauHieu
        OPTIONAL MATCH (t)-[:CO_CONG_THUC]->(f:CongThuc)
        RETURN t.ten AS ten, t.moTa AS moTa, t.meo AS meo,
          tinhChat, dauHieu,
          collect(DISTINCT CASE WHEN f IS NULL THEN null ELSE
            {ten:f.ten, bieuThuc:f.bieuThuc, bienSo:f.bienSo} END) AS congThuc""",
        ten=ten,
    )
    if not rows:
        return {}
    result = rows[0]
    result["tinhChat"] = [x for x in result["tinhChat"] if x is not None]
    result["dauHieu"] = [x for x in result["dauHieu"] if x is not None]
    result["congThuc"] = [x for x in result["congThuc"] if x is not None]
    return result


def get_hierarchy() -> list[tuple[str, str]]:
    """Lấy các cặp quan hệ phân cấp (con, cha)."""
    return [(r["con"], r["cha"]) for r in _read(
        "MATCH (con:TuGiac)-[:LA_MOT]->(cha:TuGiac) RETURN con.ten AS con, cha.ten AS cha ORDER BY con, cha"
    )]


def search(keyword: str) -> list[dict]:
    """Tìm tên hình, tính chất và dấu hiệu theo từ khóa không phân biệt hoa thường."""
    return _read(
        """CALL {
          MATCH (t:TuGiac) WHERE toLower(t.ten) CONTAINS toLower($keyword)
            OR toLower(t.moTa) CONTAINS toLower($keyword)
          RETURN t.ten AS ten, 'TuGiac' AS loai, t.moTa AS noiDung
          UNION ALL
          MATCH (t:TuGiac)-[:CO_TINH_CHAT]->(p:TinhChat)
          WHERE toLower(p.noiDung) CONTAINS toLower($keyword)
          RETURN t.ten AS ten, 'TinhChat' AS loai, p.noiDung AS noiDung
          UNION ALL
          MATCH (t:TuGiac)-[:NHAN_BIET_BOI]->(d:DauHieu)
          WHERE toLower(d.noiDung) CONTAINS toLower($keyword)
          RETURN t.ten AS ten, 'DauHieu' AS loai, d.noiDung AS noiDung
        }
        RETURN ten, loai, noiDung ORDER BY ten, loai""",
        keyword=keyword,
    )


def get_exercises(ten: str = None, muc_do: str = None) -> list[dict]:
    """Lấy bài tập, có thể lọc theo tên tứ giác và mức độ."""
    return _read(
        """MATCH (b:BaiTap)-[:THUOC_VE]->(t:TuGiac)
        WHERE ($ten IS NULL OR t.ten=$ten) AND ($muc_do IS NULL OR b.mucDo=$muc_do)
        RETURN elementId(b) AS id, b.de AS de, b.dapAn AS dapAn,
          b.mucDo AS mucDo, t.ten AS tuGiac ORDER BY t.ten, b.mucDo""",
        ten=ten, muc_do=muc_do,
    )


def add_exercise(de: str, dap_an: str, muc_do: str, ten_tu_giac: str) -> str:
    """Thêm bài tập và liên kết với loại tứ giác, trả về elementId của bài."""
    rows = _write(
        """MATCH (t:TuGiac {ten:$ten}) CREATE (b:BaiTap {de:$de, dapAn:$dap_an, mucDo:$muc_do})
        CREATE (b)-[:THUOC_VE]->(t) RETURN elementId(b) AS id""",
        de=de, dap_an=dap_an, muc_do=muc_do, ten=ten_tu_giac,
    )
    return rows[0]["id"] if rows else ""


def update_exercise(id: str, de: str, dap_an: str, muc_do: str) -> bool:
    """Cập nhật nội dung, đáp án và mức độ bài tập theo elementId."""
    rows = _write(
        """MATCH (b:BaiTap) WHERE elementId(b)=$id
        SET b.de=$de, b.dapAn=$dap_an, b.mucDo=$muc_do RETURN count(b) AS n""",
        id=id, de=de, dap_an=dap_an, muc_do=muc_do,
    )
    return bool(rows and rows[0]["n"])


def delete_exercise(id: str) -> bool:
    """Xóa bài tập theo elementId và báo có xóa được bản ghi hay không."""
    rows = _write(
        "MATCH (b:BaiTap) WHERE elementId(b)=$id WITH b DETACH DELETE b RETURN count(*) AS n",
        id=id,
    )
    return bool(rows and rows[0]["n"])


def add_property(ten_tu_giac: str, noi_dung: str) -> str:
    """Thêm tính chất cho tứ giác và trả về elementId của tính chất."""
    rows = _write(
        """MATCH (t:TuGiac {ten:$ten}) CREATE (p:TinhChat {noiDung:$noi_dung})
        CREATE (t)-[:CO_TINH_CHAT]->(p) RETURN elementId(p) AS id""",
        ten=ten_tu_giac, noi_dung=noi_dung,
    )
    return rows[0]["id"] if rows else ""


def update_property(id: str, noi_dung: str) -> bool:
    """Cập nhật nội dung tính chất theo elementId."""
    rows = _write(
        "MATCH (p:TinhChat) WHERE elementId(p)=$id SET p.noiDung=$noi_dung RETURN count(p) AS n",
        id=id, noi_dung=noi_dung,
    )
    return bool(rows and rows[0]["n"])


def delete_property(id: str) -> bool:
    """Xóa tính chất theo elementId và báo kết quả."""
    rows = _write(
        "MATCH (p:TinhChat) WHERE elementId(p)=$id WITH p DETACH DELETE p RETURN count(*) AS n",
        id=id,
    )
    return bool(rows and rows[0]["n"])


def get_quiz(so_cau: int = 5) -> list[dict]:
    """Lấy ngẫu nhiên số câu quiz yêu cầu, kèm đáp án và loại tứ giác."""
    return _read(
        """MATCH (q:CauHoi)-[:THUOC_VE]->(t:TuGiac)
        WITH q, t ORDER BY rand() LIMIT $so_cau
        RETURN elementId(q) AS id, q.noiDung AS noiDung, q.luaChon AS luaChon,
          q.dapAnDung AS dapAnDung, t.ten AS tuGiac""",
        so_cau=max(0, int(so_cau)),
    )


def save_result(ten_nguoi_choi: str, cau_hoi_id: str, dung: bool) -> int:
    """Lưu lượt trả lời, cộng 10 điểm nếu đúng và trả tổng điểm mới."""
    rows = _write(
        """MATCH (q:CauHoi) WHERE elementId(q)=$cau_hoi_id
        MERGE (n:NguoiChoi {ten:$ten}) ON CREATE SET n.tongDiem=0
        MERGE (n)-[r:DA_LAM]->(q)
        WITH n, r, CASE WHEN $dung THEN 10 ELSE 0 END AS diem
        SET r.dung=$dung, r.diem=coalesce(r.diem,0)+diem, r.thoiGian=datetime()
        SET n.tongDiem=coalesce(n.tongDiem,0)+diem
        RETURN n.tongDiem AS tongDiem""",
        ten=ten_nguoi_choi, cau_hoi_id=cau_hoi_id, dung=bool(dung),
    )
    return int(rows[0]["tongDiem"]) if rows else 0


def get_leaderboard(gioi_han: int = 10) -> list[dict]:
    """Lấy bảng xếp hạng theo tổng điểm giảm dần."""
    return _read(
        "MATCH (n:NguoiChoi) RETURN n.ten AS ten, n.tongDiem AS tongDiem ORDER BY tongDiem DESC, ten LIMIT $gioi_han",
        gioi_han=max(0, int(gioi_han)),
    )
