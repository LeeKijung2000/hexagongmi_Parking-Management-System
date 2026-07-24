<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PARK SMART - 정기권 조회</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <style>
        :root {
            --primary: #2563eb;
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --radius: 12px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Pretendard Variable", Pretendard, sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); min-height: 100vh; display: flex; flex-direction: column; }
        
        header { background: #0f172a; color: #ffffff; padding: 1.25rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .logo-badge { background: var(--primary); font-size: 0.75rem; padding: 2px 8px; border-radius: 20px; font-weight: 600; }
        
        nav { background: #1e293b; padding: 0 2rem; display: flex; gap: 1rem; box-shadow: var(--shadow-sm); }
        nav a { color: #94a3b8; text-decoration: none; padding: 1rem 1.25rem; font-size: 0.95rem; font-weight: 500; border-bottom: 2px solid transparent; }
        nav a:hover, nav a.active { color: #ffffff; border-bottom-color: var(--primary); }
        
        main { flex: 1; max-width: 1000px; width: 100%; margin: 3rem auto; padding: 0 1.5rem; }
        .card { background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color); padding: 2rem; }
        .card-header { margin-bottom: 1.5rem; }
        .card-title { font-size: 1.5rem; font-weight: 700; }
        
        /* Modern Table Style */
        .table-responsive { width: 100%; overflow-x: auto; }
        .custom-table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.925rem; }
        .custom-table th { background: #f1f5f9; padding: 1rem; font-weight: 600; color: #475569; border-bottom: 2px solid var(--border-color); }
        .custom-table td { padding: 1rem; border-bottom: 1px solid var(--border-color); color: #334155; }
        .custom-table tbody tr:hover { background-color: #f8fafc; }

        /* Status Badge */
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: 600; }
        .badge-active { background: #dcfce7; color: #15803d; }
        .badge-inactive { background: #fee2e2; color: #b91c1c; }

        /* Pagination */
        .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 1.5rem; }
        .pagination a { padding: 8px 14px; text-decoration: none; color: var(--text-main); border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.875rem; font-weight: 500; }
        .pagination a.active { background-color: var(--primary); color: white; border-color: var(--primary); }
        
        @media (max-width: 640px) { nav { overflow-x: auto; white-space: nowrap; } }
    </style>
</head>
<body>
    <header>
        <div class="logo"><span>PARK SMART</span><span class="logo-badge">v1.0</span></div>
    </header>

    <nav>
        <a href="${pageContext.request.contextPath}/ticket/register.do">정기권 등록</a>
        <a href="${pageContext.request.contextPath}/ticket/list.do" class="active">정기권 조회</a>
        <a href="${pageContext.request.contextPath}/park/inout.do">입·출고 관리</a>
        <a href="${pageContext.request.contextPath}/park/status.do">주차 현황</a>
    </nav>

    <main>
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">정기권 목록 조회</h2>
            </div>

            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>차량번호</th>
                            <th>차주전화</th>
                            <th>주차등급</th>
                            <th>상태</th>
                            <th>주차시작일</th>
                            <th>주차종료일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${ticketPage.hasNoTickets()}">
                            <tr><td colspan="7" style="text-align: center; color: var(--text-sub);">등록된 정기권 정보가 없습니다.</td></tr>
                        </c:if>
                        <c:forEach var="ticket" items="${ticketPage.content}">
                            <tr>
                                <td>${ticket.tno}</td>
                                <td style="font-weight: 600;">${ticket.carno}</td>
                                <td>${ticket.phone}</td>
                                <td>${ticket.grade == 'M' ? '월회원' : (ticket.grade == 'D' ? '일회원' : '년회원')}</td>
                                <td>
                                    <span class="badge ${ticket.tstat == 'Y' ? 'badge-active' : 'badge-inactive'}">
                                        ${ticket.tstat == 'Y' ? '사용가능' : '사용불가'}
                                    </span>
                                </td>
                                <td><fmt:formatDate value="${ticket.startdate}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatDate value="${ticket.enddate}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 영역 -->
            <c:if test="${ticketPage.hasTickets()}">
                <div class="pagination">
                    <c:if test="${ticketPage.startPage > 5}">
                        <a href="${pageContext.request.contextPath}/ticket/list.do?pageNo=${ticketPage.startPage - 5}">이전</a>
                    </c:if>

                    <c:forEach var="pNo" begin="${ticketPage.startPage}" end="${ticketPage.endPage}">
                        <a href="${pageContext.request.contextPath}/ticket/list.do?pageNo=${pNo}" class="${ticketPage.currentPage == pNo ? 'active' : ''}">${pNo}</a>
                    </c:forEach>

                    <c:if test="${ticketPage.endPage < ticketPage.totalPages}">
                        <a href="${pageContext.request.contextPath}/ticket/list.do?pageNo=${ticketPage.startPage + 5}">다음</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</body>
</html>