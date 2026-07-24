<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PARK SMART - 입·출고 관리</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --success: #16a34a;
            --danger: #dc2626;
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
        
        main { flex: 1; max-width: 680px; width: 100%; margin: 3rem auto; padding: 0 1.5rem; }
        .card { background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color); padding: 2.5rem; }
        .card-header { margin-bottom: 2rem; }
        
        .search-row { display: flex; gap: 8px; margin-bottom: 2rem; }
        .search-row input[type="text"] { flex: 1; padding: 0.75rem 1rem; border: 1px solid var(--border-color); border-radius: 8px; outline: none; font-size: 0.95rem; }
        .btn-search { padding: 0.75rem 1.2rem; border: none; border-radius: 8px; font-weight: 600; color: white; cursor: pointer; transition: opacity 0.2s; }
        .btn-search-in { background-color: var(--primary); }
        .btn-search-out { background-color: #475569; }
        .btn-search:hover { opacity: 0.9; }

        .info-grid { display: grid; grid-template-columns: 120px 1fr; gap: 1rem; background: #f8fafc; padding: 1.25rem; border-radius: 8px; border: 1px solid var(--border-color); }
        .info-label { font-weight: 600; color: var(--text-sub); }
        .info-value { color: var(--text-main); font-weight: 500; }

        .btn-action { margin-top: 1.5rem; width: 100%; padding: 1rem; border: none; border-radius: 8px; font-size: 1rem; font-weight: 700; color: white; cursor: pointer; }
        .btn-action-in { background-color: var(--success); }
        .btn-action-out { background-color: var(--danger); }
        
        @media (max-width: 640px) { nav { overflow-x: auto; white-space: nowrap; } }
    </style>
    <script>
        <c:if test="${not empty msg}">alert("${msg}");</c:if>

        function searchVehicle(mode) {
            var carno = document.getElementById("carnoInput").value.trim();
            if(!carno) {
                alert("차량번호를 입력하세요.");
                return;
            }
            var form = document.getElementById("actionForm");
            form.carno.value = carno;
            form.action.value = (mode === 'IN') ? 'searchIn' : 'searchOut';
            form.submit();
        }

        function confirmAction(mode) {
            var msg = (mode === 'IN') ? "입고 처리하시겠습니까?" : "출고 처리하시겠습니까?";
            if (confirm(msg)) {
                var form = document.getElementById("actionForm");
                form.action.value = (mode === 'IN') ? 'doIn' : 'doOut';
                form.submit();
            }
        }
    </script>
</head>
<body>
    <header>
        <div class="logo"><span>PARK SMART</span><span class="logo-badge">v1.0</span></div>
    </header>

    <nav>
        <a href="${pageContext.request.contextPath}/ticket/register.do">정기권 등록</a>
        <a href="${pageContext.request.contextPath}/ticket/list.do">정기권 조회</a>
        <a href="${pageContext.request.contextPath}/park/inout.do" class="active">입·출고 관리</a>
        <a href="${pageContext.request.contextPath}/park/status.do">주차 현황</a>
    </nav>

    <main>
        <div class="card">
            <div class="card-header">
                <h2 style="font-size: 1.5rem; font-weight: 700;">주차차량 입·출고</h2>
                <p style="font-size: 0.875rem; color: var(--text-sub); margin-top: 0.25rem;">차량번호 검색을 통해 입고 및 출고를 진행합니다.</p>
            </div>

            <!-- 검색 영역 -->
            <div class="search-row">
                <input type="text" id="carnoInput" value="${param.carno}" placeholder="차량번호 (예: 12가3456)">
                <button type="button" class="btn-search btn-search-in" onclick="searchVehicle('IN')">입고 조회</button>
                <button type="button" class="btn-search btn-search-out" onclick="searchVehicle('OUT')">출고 조회</button>
            </div>

            <!-- 전송 Form -->
            <form id="actionForm" action="${pageContext.request.contextPath}/park/inout.do" method="post">
                <input type="hidden" name="action" value="">
                <input type="hidden" name="carno" value="${ticket.carno}">
                <input type="hidden" name="grade" value="${ticket.grade}">
            </form>

            <!-- 정기권 정보 표시 -->
            <c:if test="${not empty ticket}">
                <div class="info-grid">
                    <span class="info-label">정기권 번호</span><span class="info-value">${ticket.tno}</span>
                    <span class="info-label">차량 번호</span><span class="info-value" style="font-weight: 700; color: var(--primary);">${ticket.carno}</span>
                    <span class="info-label">차주 연락처</span><span class="info-value">${ticket.phone}</span>
                    <span class="info-label">주차 등급</span><span class="info-value">${ticket.grade == 'M' ? '월회원' : (ticket.grade == 'D' ? '일회원' : '년회원')}</span>
                    <span class="info-label">정기권 상태</span><span class="info-value">${ticket.tstat == 'Y' ? '주차 가능' : '주차 불가능'}</span>
                    <span class="info-label">가입 일자</span><span class="info-value"><fmt:formatDate value="${ticket.startdate}" pattern="yyyy-MM-dd"/></span>
                    <span class="info-label">마감 일자</span><span class="info-value"><fmt:formatDate value="${ticket.enddate}" pattern="yyyy-MM-dd"/></span>
                </div>

                <c:if test="${mode == 'IN'}">
                    <button class="btn-action btn-action-in" onclick="confirmAction('IN')">입고 승인 및 확정</button>
                </c:if>
                <c:if test="${mode == 'OUT'}">
                    <button class="btn-action btn-action-out" onclick="confirmAction('OUT')">출고 승인 및 정산</button>
                </c:if>
            </c:if>
        </div>
    </main>
</body>
</html>