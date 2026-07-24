package mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import jdbc.JdbcUtil;
import mvc.model.ParkInfo;

public class ParkInfoDao {

    // 1. 입고 처리 (INSERT)
    public int insertIn(Connection conn, ParkInfo parkInfo) throws SQLException {
        String sql = "INSERT INTO park_info_tbl (parkno, carno, grade, tstat, indate, outdate) "
                   + "VALUES (seq_park_info_parkno.NEXTVAL, ?, ?, 'I', SYSDATE, NULL)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, parkInfo.getCarno());
            pstmt.setString(2, parkInfo.getGrade());
            return pstmt.executeUpdate();
        }
    }

    // 2. 출고 처리 (UPDATE: 현재 입고 상태('I')인 가장 최근 기록 업데이트)
    public int updateOut(Connection conn, String carno) throws SQLException {
        String sql = "UPDATE park_info_tbl SET tstat = 'O', outdate = SYSDATE "
                   + "WHERE carno = ? AND tstat = 'I'";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, carno);
            return pstmt.executeUpdate();
        }
    }

    // 3. 현재 주차 상태 확인 (입고 중인지 여부 검사)
    public boolean isParking(Connection conn, String carno) throws SQLException {
        String sql = "SELECT COUNT(*) FROM park_info_tbl WHERE carno = ? AND tstat = 'I'";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, carno);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
    
    // 4. 주차 내역 전체 개수 조회
    public int selectCount(Connection conn) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COUNT(*) FROM park_info_tbl");
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(stmt);
        }
    }

    // ROWNUM 페이징 처리된 주차 내역 목록 조회 (최신순)
    public List<ParkInfo> select(Connection conn, int startRow, int size) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM ("
                       + "  SELECT ROWNUM AS rnum, p.* FROM ("
                       + "    SELECT * FROM park_info_tbl ORDER BY parkno DESC"
                       + "  ) p WHERE ROWNUM <= ?"
                       + ") WHERE rnum >= ?";

            pstmt = conn.prepareStatement(sql);
            
            int endRow = startRow + size;
            int firstRow = startRow + 1;

            pstmt.setInt(1, endRow);
            pstmt.setInt(2, firstRow);

            rs = pstmt.executeQuery();
            List<ParkInfo> result = new ArrayList<>();
            while (rs.next()) {
                result.add(convertParkInfo(rs));
            }
            return result;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    // ResultSet -> ParkInfo 변환 헬퍼 메서드
    private ParkInfo convertParkInfo(ResultSet rs) throws SQLException {
        return new ParkInfo(
            rs.getInt("parkno"),
            rs.getString("carno"),
            rs.getString("grade"),
            rs.getString("tstat"),
            rs.getTimestamp("indate"),
            rs.getTimestamp("outdate")
        );
    }
}