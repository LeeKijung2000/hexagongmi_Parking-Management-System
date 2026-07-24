package mvc.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.service.ParkStatusPage;
import mvc.service.ParkStatusService;

public class ParkStatusHandler implements CommandHandler {

    private ParkStatusService statusService = new ParkStatusService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String pageNoVal = req.getParameter("pageNo");
        int pageNo = 1;

        if (pageNoVal != null) {
            pageNo = Integer.parseInt(pageNoVal);
        }

        ParkStatusPage parkStatusPage = statusService.getParkStatusPage(pageNo);
        req.setAttribute("parkStatusPage", parkStatusPage);

        return "/WEB-INF/view/parkStatus.jsp";
    }
}