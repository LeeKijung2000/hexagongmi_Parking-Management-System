package mvc.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.model.Ticket;
import mvc.service.ParkInOutService;

public class ParkInOutHandler implements CommandHandler {

    private static final String FORM_VIEW = "/WEB-INF/view/parkInOut.jsp";
    private ParkInOutService parkService = new ParkInOutService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action"); // search, in, out

        if (action == null || action.isEmpty()) {
            return FORM_VIEW;
        }

        String carno = req.getParameter("carno");

        // 1. 차량 검색 (입고/출고 구분 검색)
        if ("searchIn".equals(action) || "searchOut".equals(action)) {
            Ticket ticket = parkService.getTicketByCarno(carno);
            if (ticket == null) {
                req.setAttribute("msg", "등록되지 않은 정기권 차량입니다.");
            } else {
                req.setAttribute("ticket", ticket);
                req.setAttribute("mode", "searchIn".equals(action) ? "IN" : "OUT");
            }
            return FORM_VIEW;
        }

        // 2. 입고 실행
        if ("doIn".equals(action)) {
            String grade = req.getParameter("grade");
            boolean success = parkService.processIn(carno, grade);
            if (success) {
                req.setAttribute("msg", "차량 입고가 완료되었습니다.");
            } else {
                req.setAttribute("msg", "이미 입고되어 있는 차량입니다.");
            }
            return FORM_VIEW;
        }

        // 3. 출고 실행
        if ("doOut".equals(action)) {
            boolean success = parkService.processOut(carno);
            if (success) {
                req.setAttribute("msg", "차량 출고가 완료되었습니다.");
            } else {
                req.setAttribute("msg", "입고된 내역이 없는 차량입니다.");
            }
            return FORM_VIEW;
        }

        return FORM_VIEW;
    }
}