package mvc.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import mvc.model.Ticket;
import mvc.dao.TicketDao;

public class TicketRegisterService {

    private TicketDao ticketDao = new TicketDao();

    public Ticket register(TicketRequest req) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // Ticket 객체 생성
            Ticket ticket = new Ticket(
                0, 
                req.getCarno(),
                req.getPhone(),
                req.getGrade(),
                req.getTstat(),
                req.getStartdate(),
                req.getEnddate()
            );

            Ticket savedTicket = ticketDao.insert(conn, ticket);
            if (savedTicket == null) {
                JdbcUtil.rollback(conn); // 등록 실패 시 롤백
                throw new RuntimeException("정기권 등록 실패");
            }

            conn.commit(); // 성공 시 커밋
            return savedTicket;

        } catch (SQLException e) {
            JdbcUtil.rollback(conn); // 예외 발생 시 롤백
            throw new RuntimeException(e);
        } finally {
            JdbcUtil.close(conn); // 커넥션 닫기
        }
    }
}