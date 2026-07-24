package mvc.service;

import java.util.List;
import mvc.model.Ticket;

public class TicketPage {

    private int total;          // 전체 데이터 개수
    private int currentPage;    // 현재 페이지
    private List<Ticket> content; // 정기권 목록
    private int totalPages;     // 전체 페이지 수
    private int startPage;      // 페이지 블록 시작
    private int endPage;        // 페이지 블록 끝

    public TicketPage(int total, int currentPage, int size, List<Ticket> content) {
        this.total = total;
        this.currentPage = currentPage;
        this.content = content;

        if (total == 0) {
            totalPages = 0;
            startPage = 0;
            endPage = 0;
        } else {
            totalPages = total / size;
            if (total % size > 0) {
                totalPages++;
            }

            int modVal = currentPage % 5;
            startPage = currentPage / 5 * 5 + 1;
            if (modVal == 0) startPage -= 5;

            endPage = startPage + 4;
            if (endPage > totalPages) {
                endPage = totalPages;
            }
        }
    }

    public int getTotal() { return total; }
    public boolean hasNoTickets() { return total == 0; }
    public boolean hasTickets() { return total > 0; }
    public int getCurrentPage() { return currentPage; }
    public int getTotalPages() { return totalPages; }
    public List<Ticket> getContent() { return content; }
    public int getStartPage() { return startPage; }
    public int getEndPage() { return endPage; }
}