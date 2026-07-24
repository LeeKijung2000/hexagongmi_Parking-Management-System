package mvc.command;

import java.text.SimpleDateFormat;
import java.util.Calendar; 
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.service.TicketListService; // 기존 조회 서비스 임포트
import mvc.service.TicketRegisterService;
import mvc.service.TicketRequest;

public class TicketRegisterHandler implements CommandHandler {

    private static final String FORM_VIEW = "/index.jsp";
    private TicketRegisterService registerService = new TicketRegisterService();
    private TicketListService listService = new TicketListService(); // 1. 조회 서비스 주입

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        if (req.getMethod().equalsIgnoreCase("GET")) {
            return processForm(req, res); 
        } else if (req.getMethod().equalsIgnoreCase("POST")) {
            return processSubmit(req, res); 
        } else {
            res.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED); 
            return null;
        }
    }

    // GET 요청 시: 등록 폼으로 가기 전에 '다음 주차권 번호'를 조회해서 req에 담음
    private String processForm(HttpServletRequest req, HttpServletResponse res) throws Exception {
        setNextTno(req); // 공통 메서드로 번호 조회 및 세팅
        return FORM_VIEW; 
    }

    private String processSubmit(HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setCharacterEncoding("UTF-8");
        Map<String, Boolean> errors = new HashMap<>();
        req.setAttribute("errors", errors); 

        // 폼 파라미터 바인딩
        TicketRequest ticketReq = new TicketRequest();
        ticketReq.setCarno(req.getParameter("carno"));
        ticketReq.setPhone(req.getParameter("phone"));
        ticketReq.setGrade(req.getParameter("grade"));
        ticketReq.setTstat(req.getParameter("tstat"));

        // 날짜 변환 및 종료일(enddate) 자동 계산 로직
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            String startDateStr = req.getParameter("startdate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                Date startDate = sdf.parse(startDateStr);
                ticketReq.setStartdate(startDate);

                // 주차증급(grade)에 따른 마감일자(enddate) 자동 계산
                Calendar cal = Calendar.getInstance();
                cal.setTime(startDate);

                String grade = ticketReq.getGrade();
                if ("D".equals(grade)) {
                    cal.add(Calendar.DATE, 1);    // 일 주차: +1일
                } else if ("M".equals(grade)) {
                    cal.add(Calendar.DATE, 30);   // 월 주차: +30일
                } else if ("Y".equals(grade)) {
                    cal.add(Calendar.DATE, 365);  // 년 주차: +365일
                }

                ticketReq.setEnddate(cal.getTime()); // 자동 계산된 종료일 세팅
            }
        } catch (Exception e) {
            errors.put("invalidDate", Boolean.TRUE);
        }

        // 유효성 검증
        ticketReq.validate(errors);

        if (!errors.isEmpty()) {
            setNextTno(req); // 2. 에러가 나서 다시 등록 폼으로 돌아갈 때도 번호 다시 전달
            return FORM_VIEW; 
        }

        // 서비스 호출 및 결과 메시지 세팅
        registerService.register(ticketReq);
        req.setAttribute("msg", "정기권 등록이 완료되었습니다.");
        
        // 3. 등록 완료 후 다시 index.jsp로 돌아갈 때 업데이트된 다음 번호 전달
        setNextTno(req); 
        
        return FORM_VIEW;
    }

    // 다음 주차권 번호를 조회해서 request에 저장하는 메서드
    private void setNextTno(HttpServletRequest req) {
        try {
            // 프로젝트의 서비스/DAO에 구현되어 있는 방식에 맞춰 사용하세요:
            // 예시 A) 다음 시퀀스 번호 조회 메서드가 있을 경우
            int nextTno = listService.getNextTno(); 
            
            // 예시 B) 만약 전체 건수(count)를 가져오는 서비스라면: listService.getTotalCount() + 1;
            
            req.setAttribute("nextTno", nextTno);
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 시 기본값 처리
            req.setAttribute("nextTno", 1);
        }
    }
}