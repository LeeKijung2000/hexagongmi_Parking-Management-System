package mvc.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import mvc.model.ParkInfo;
import mvc.model.Ticket;
import mvc.dao.ParkInfoDao;
import mvc.dao.TicketDao;

public class ParkInOutService {

    private TicketDao ticketDao = new TicketDao();
    private ParkInfoDao parkInfoDao = new ParkInfoDao();

    // 차량번호로 정기권 정보 조회
    public Ticket getTicketByCarno(String carno) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return ticketDao.selectByCarno(conn, carno); // TicketDao에 carno로 조회하는 메서드 필요
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // 입고 처리
    public boolean processIn(String carno, String grade) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            // 이미 입고 상태인지 검사
            if (parkInfoDao.isParking(conn, carno)) {
                return false; // 이미 입고 중
            }

            ParkInfo parkInfo = new ParkInfo(0, carno, grade, "I", null, null);
            parkInfoDao.insertIn(conn, parkInfo);
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } finally {
            JdbcUtil.close(conn);
        }
    }

    // 출고 처리
    public boolean processOut(String carno) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            // 입고 중인 차량이 아니면 출고 불가
            if (!parkInfoDao.isParking(conn, carno)) {
                return false;
            }

            parkInfoDao.updateOut(conn, carno);
            conn.commit();
            return true;
        } catch (SQLException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
}