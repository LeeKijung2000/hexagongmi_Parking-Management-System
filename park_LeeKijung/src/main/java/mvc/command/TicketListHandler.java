package mvc.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.service.TicketListService;
import mvc.service.TicketPage;

public class TicketListHandler implements CommandHandler {

    private TicketListService listService = new TicketListService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String pageNoVal = req.getParameter("pageNo");
        int pageNo = 1;
        
        if (pageNoVal != null) {
            pageNo = Integer.parseInt(pageNoVal);
        }

        TicketPage ticketPage = listService.getTicketPage(pageNo);
        req.setAttribute("ticketPage", ticketPage);

        return "/WEB-INF/view/ticketList.jsp";
    }
}