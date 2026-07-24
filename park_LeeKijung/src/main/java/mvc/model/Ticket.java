package mvc.model;

import java.util.Date;

public class Ticket {
    private int tno;            // 정기주차권번호 (PK)
    private String carno;       // 차량번호
    private String phone;       // 차주전화
    private String grade;       // 주차증급 (M: 월, Y: 년)
    private String tstat;       // 정기권상태 (Y: 주차가능, N: 주차불가능)
    private Date startdate;     // 입고가입일자
    private Date enddate;       // 출고마감일자

    // 기본 생성자
    public Ticket() {
    }

    // 매개변수 생성자
    public Ticket(int tno, String carno, String phone, String grade, String tstat, Date startdate, Date enddate) {
        this.tno = tno;
        this.carno = carno;
        this.phone = phone;
        this.grade = grade;
        this.tstat = tstat;
        this.startdate = startdate;
        this.enddate = enddate;
    }

    // Getter & Setter
    public int getTno() {
        return tno;
    }

    public void setTno(int tno) {
        this.tno = tno;
    }

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

    @Override
    public String toString() {
        return "Ticket [tno=" + tno + ", carno=" + carno + ", phone=" + phone + ", grade=" + grade 
                + ", tstat=" + tstat + ", startdate=" + startdate + ", enddate=" + enddate + "]";
    }
}