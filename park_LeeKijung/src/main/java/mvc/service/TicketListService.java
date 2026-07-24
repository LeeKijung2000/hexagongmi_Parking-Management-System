package mvc.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import jdbc.connection.ConnectionProvider;
import mvc.model.Ticket;
import mvc.dao.TicketDao;

public class TicketListService {

    private TicketDao ticketDao = new TicketDao();
    private int size = 5; // 한 페이지에 5개씩 출력

    public TicketPage getTicketPage(int pageNum) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            int total = ticketDao.selectCount(conn);
            List<Ticket> content = ticketDao.select(conn, (pageNum - 1) * size, size);
            
            return new TicketPage(total, pageNum, size, content);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public int getNextTno() {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return ticketDao.selectNextTno(conn);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}