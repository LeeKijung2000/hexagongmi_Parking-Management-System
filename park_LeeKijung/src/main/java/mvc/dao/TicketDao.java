package mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jdbc.JdbcUtil;
import mvc.model.Ticket;

public class TicketDao {

    // insert() 메서드는 그대로 유지
    public Ticket insert(Connection conn, Ticket ticket) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String[] keyColumn = new String[] { "tno" };
            String sql = "INSERT INTO ticket_tbl_01 (tno, carno, phone, grade, tstat, startdate, enddate) "
                       + "VALUES (seq_ticket_tno.NEXTVAL, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, keyColumn);
            pstmt.setString(1, ticket.getCarno());
            pstmt.setString(2, ticket.getPhone());
            pstmt.setString(3, ticket.getGrade());
            pstmt.setString(4, ticket.getTstat());
            pstmt.setTimestamp(5, toTimestamp(ticket.getStartdate()));
            pstmt.setTimestamp(6, toTimestamp(ticket.getEnddate()));
            
            int insertedCount = pstmt.executeUpdate();
            if (insertedCount > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int newTno = rs.getInt(1);
                    return new Ticket(newTno, ticket.getCarno(), ticket.getPhone(), 
                                      ticket.getGrade(), ticket.getTstat(), 
                                      ticket.getStartdate(), ticket.getEnddate());
                }
            }
            return null;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    // 정기권 전체 개수 조회
    public int selectCount(Connection conn) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ticket_tbl_01");
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(stmt);
        }
    }

    // ROWNUM 페이징 처리된 목록 조회 
    public List<Ticket> select(Connection conn, int startRow, int size) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT * FROM ("
                       + "  SELECT ROWNUM AS rnum, t.* FROM ("
                       + "    SELECT * FROM ticket_tbl_01 ORDER BY tno DESC"
                       + "  ) t WHERE ROWNUM <= ?"
                       + ") WHERE rnum >= ?";

            pstmt = conn.prepareStatement(sql);
            
            int endRow = startRow + size;
            int firstRow = startRow + 1;

            pstmt.setInt(1, endRow);
            pstmt.setInt(2, firstRow);

            rs = pstmt.executeQuery();
            List<Ticket> result = new ArrayList<>();
            while (rs.next()) {
                result.add(convertTicket(rs));
            }
            return result;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
    
    public Ticket selectByCarno(Connection conn, String carno) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("SELECT * FROM ticket_tbl_01 WHERE carno = ?");
            pstmt.setString(1, carno);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return convertTicket(rs);
            }
            return null;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
    
    // 다음 주차권 번호(tno) 조회 메서드
    public int selectNextTno(Connection conn) throws SQLException {
        // 1) MAX(tno) + 1 방식을 쓰는 경우 (추천: 직관적)
        String sql = "SELECT NVL(MAX(tno), 0) + 1 FROM ticket_tbl_01";
        
        // 2) 만약 시퀀스 가상 칼럼을 직접 조회할 경우: 
        // String sql = "SELECT seq_ticket_tno.NEXTVAL FROM dual"; 
        // (주의: NEXTVAL은 호출할 때마다 번호가 실제 증가하므로 MAX(tno)+1이 안전합니다)

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 1;
        }
    }
    

    // ResultSet -> Ticket 변환 헬퍼 메서드
    private Ticket convertTicket(ResultSet rs) throws SQLException {
        return new Ticket(
            rs.getInt("tno"),
            rs.getString("carno"),
            rs.getString("phone"),
            rs.getString("grade"),
            rs.getString("tstat"),
            rs.getTimestamp("startdate"),
            rs.getTimestamp("enddate")
        );
    }

    private Timestamp toTimestamp(Date date) {
        return date == null ? null : new Timestamp(date.getTime());
    }
}