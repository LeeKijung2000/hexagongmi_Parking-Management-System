package mvc.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import jdbc.connection.ConnectionProvider;
import mvc.model.ParkInfo;
import mvc.dao.ParkInfoDao;

public class ParkStatusService {

    private ParkInfoDao parkInfoDao = new ParkInfoDao();
    private int size = 5; // 한 페이지에 5개씩 출력

    public ParkStatusPage getParkStatusPage(int pageNum) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            int total = parkInfoDao.selectCount(conn);
            List<ParkInfo> content = parkInfoDao.select(conn, (pageNum - 1) * size, size);

            return new ParkStatusPage(total, pageNum, size, content);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}