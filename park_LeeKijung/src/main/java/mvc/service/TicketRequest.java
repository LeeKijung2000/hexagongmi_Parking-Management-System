package mvc.service;

import java.util.Date;
import java.util.Map;

public class TicketRequest {

    private String carno;       // 차량번호
    private String phone;       // 차주전화
    private String grade;       // 주차증급 (M:월, Y:년)
    private String tstat;       // 정기권상태 (Y:가능, N:불가능)
    private Date startdate;     // 입고가입일자
    private Date enddate;       // 출고마감일자

    public String getCarno() {
        return carno;
    }

    public void setCarno(String carno) {
        this.carno = carno;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getTstat() {
        return tstat;
    }

    public void setTstat(String tstat) {
        this.tstat = tstat;
    }

    public Date getStartdate() {
        return startdate;
    }

    public void setStartdate(Date startdate) {
        this.startdate = startdate;
    }

    public Date getEnddate() {
        return enddate;
    }

    public void setEnddate(Date enddate) {
        this.enddate = enddate;
    }

    // 필수 항목 검사
    public void validate(Map<String, Boolean> errors) {
        checkEmpty(errors, carno, "carno");
        checkEmpty(errors, phone, "phone");
        checkEmpty(errors, grade, "grade");
        checkEmpty(errors, tstat, "tstat");
        if (startdate == null) errors.put("startdate", Boolean.TRUE);
        if (enddate == null) errors.put("enddate", Boolean.TRUE);
    }

    private void checkEmpty(Map<String, Boolean> errors, String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            errors.put(fieldName, Boolean.TRUE);
        }
    }
}