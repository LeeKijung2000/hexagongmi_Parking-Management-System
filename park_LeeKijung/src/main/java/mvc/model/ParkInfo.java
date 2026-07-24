package mvc.model;

import java.util.Date;

public class ParkInfo {
    private int parkno;         // 주차번호 (PK)
    private String carno;       // 차량번호
    private String grade;       // 주차등급 (M: 월, Y: 년)
    private String tstat;       // 입출고상태 (I: 입고, O: 출고)
    private Date indate;        // 입고일자시간
    private Date outdate;       // 출고일자시간

    // 기본 생성자
    public ParkInfo() {
    }

    // 매개변수 생성자
    public ParkInfo(int parkno, String carno, String grade, String tstat, Date indate, Date outdate) {
        this.parkno = parkno;
        this.carno = carno;
        this.grade = grade;
        this.tstat = tstat;
        this.indate = indate;
        this.outdate = outdate;
    }

    // Getter & Setter
    public int getParkno() {
        return parkno;
    }

    public void setParkno(int parkno) {
        this.parkno = parkno;
    }

    public String getCarno() {
        return carno;
    }

    public void setCarno(String carno) {
        this.carno = carno;
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

    public Date getIndate() {
        return indate;
    }

    public void setIndate(Date indate) {
        this.indate = indate;
    }

    public Date getOutdate() {
        return outdate;
    }

    public void setOutdate(Date outdate) {
        this.outdate = outdate;
    }

    @Override
    public String toString() {
        return "ParkInfo [parkno=" + parkno + ", carno=" + carno + ", grade=" + grade 
                + ", tstat=" + tstat + ", indate=" + indate + ", outdate=" + outdate + "]";
    }
}