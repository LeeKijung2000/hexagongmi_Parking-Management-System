<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PARK SMART - 주차 현황 조회</title>
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
            --shadow-lg: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Pretendard Variable", Pretendard, sans-serif; }
        body { background-color: var(--bg-body); color: var(--text-main); min-height: 100vh; display: flex; flex-direction: column; }
        
        header { background: #0f172a; color: #ffffff; padding: 1.25rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .logo-badge { background: var(--primary); font-size: 0.75rem; padding: 2px 8px; border-radius: 20px; font-weight: 600; }
        
        nav { background: #1e293b; padding: 0 2rem; display: flex; gap: 1rem; }
        nav a { color: #94a3b8; text-decoration: none; padding: 1rem 1.25rem; font-size: 0.95rem; font-weight: 500; border-bottom: 2px solid transparent; }
        nav a:hover, nav a.active { color: #ffffff; border-bottom-color: var(--primary); }
        
        main { flex: 1; max-width: 1000px; width: 100%; margin: 3rem auto; padding: 0 1.5rem; }
        .card { background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color); padding: 2rem; }
        
        .table-responsive { width: 100%; overflow-x: auto; }
        .custom-table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.925rem; }
        .custom-table th { background: #f1f5f9; padding: 1rem; font-weight: 600; color: #475569; border-bottom: 2px solid var(--border-color); }
        .custom-table td { padding: 1rem; border-bottom: 1px solid var(--border-color); color: #334155; }
        
        .status-in { background: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 12px; font-weight: 600; font-size: 0.8rem; }
        .status-out { background: #f1f5f9; color: #64748b; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; }

        .pagination { display: flex; justify-content: center; gap: 6px; margin-top: 1.5rem; }
        .pagination a { padding: 8px 14px; text-decoration: none; color: var(--text-main); border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.875rem; }
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
        <a href="${pageContext.request.contextPath}/ticket/list.do">정기권 조회</a>
        <a href="${pageContext.request.contextPath}/park/inout.do">입·출고 관리</a>
        <a href="${pageContext.request.contextPath}/park/status.do" class="active">주차 현황</a>
    </nav>

    <main>
        <div class="card">
            <div style="margin-bottom: 1.5rem;"><h2 style="font-size: 1.5rem; font-weight: 700;">실시간 주차 현황</h2></div>

            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>주차번호</th>
                            <th>차량번호</th>
                            <th>주차등급</th>
                            <th>현재상태</th>
                            <th>입고 일시</th>
                            <th>출고 일시</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${parkStatusPage.hasNoData()}">
                            <tr><td colspan="6" style="text-align: center; color: var(--text-sub);">주차 내역이 존재하지 않습니다.</td></tr>
                        </c:if>
                        <c:forEach var="park" items="${parkStatusPage.content}">
                            <tr>
                                <td>${park.parkno}</td>
                                <td style="font-weight: 600;">${park.carno}</td>
                                <td>${park.grade == 'M' ? '월회원' : (park.grade == 'D' ? '일회원' : '년회원')}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${park.tstat == 'I'}">
                                            <span class="status-in">● 주차중</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-out">출고완료</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${park.indate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty park.outdate}">
                                            <fmt:formatDate value="${park.outdate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </c:when>
                                        <c:otherwise><span style="color:#cbd5e1;">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 영역 -->
            <c:if test="${parkStatusPage.hasData()}">
                <div class="pagination">
                    <c:if test="${parkStatusPage.startPage > 5}">
                        <a href="${pageContext.request.contextPath}/park/status.do?pageNo=${parkStatusPage.startPage - 5}">이전</a>
                    </c:if>

                    <c:forEach var="pNo" begin="${parkStatusPage.startPage}" end="${parkStatusPage.endPage}">
                        <a href="${pageContext.request.contextPath}/park/status.do?pageNo=${pNo}" class="${parkStatusPage.currentPage == pNo ? 'active' : ''}">${pNo}</a>
                    </c:forEach>

                    <c:if test="${parkStatusPage.endPage < parkStatusPage.totalPages}">
                        <a href="${pageContext.request.contextPath}/park/status.do?pageNo=${parkStatusPage.startPage + 5}">다음</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</body>
</html>