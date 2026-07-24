<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PARK SMART - 정기권 등록</title>
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
            --border-focus: #3b82f6;
            --danger: #ef4444;
            --radius: 12px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Pretendard Variable", Pretendard, -apple-system, sans-serif; -webkit-font-smoothing: antialiased; }
        body { background-color: var(--bg-body); color: var(--text-main); min-height: 100vh; display: flex; flex-direction: column; }
        
        header { background: #0f172a; color: #ffffff; padding: 1.25rem 2rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
        .logo { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .logo-badge { background: var(--primary); font-size: 0.75rem; padding: 2px 8px; border-radius: 20px; font-weight: 600; }
        
        nav { background: #1e293b; padding: 0 2rem; display: flex; gap: 1rem; box-shadow: var(--shadow-sm); }
        nav a { color: #94a3b8; text-decoration: none; padding: 1rem 1.25rem; font-size: 0.95rem; font-weight: 500; transition: all 0.2s ease; border-bottom: 2px solid transparent; }
        nav a:hover, nav a.active { color: #ffffff; border-bottom-color: var(--primary); }
        
        main { flex: 1; max-width: 680px; width: 100%; margin: 3rem auto; padding: 0 1.5rem; }
        .card { background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color); padding: 2.5rem; }
        .card-header { margin-bottom: 2rem; }
        .card-title { font-size: 1.5rem; font-weight: 700; color: var(--text-main); }
        .card-subtitle { font-size: 0.875rem; color: var(--text-sub); margin-top: 0.25rem; }
        
        .form-grid { display: flex; flex-direction: column; gap: 1.5rem; }
        .form-group { display: flex; flex-direction: column; gap: 0.5rem; }
        .form-group label { font-size: 0.875rem; font-weight: 600; color: #334155; }
        
        input[type="text"], input[type="date"], select {
            width: 100%; padding: 0.75rem 1rem; font-size: 0.95rem; color: var(--text-main);
            background-color: #ffffff; border: 1px solid var(--border-color); border-radius: 8px; outline: none; transition: all 0.2s ease;
        }
        input:focus, select:focus { border-color: var(--border-focus); box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15); }
        select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2064748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 1rem center; background-size: 1.25rem; }
        
        .error-msg { font-size: 0.775rem; color: var(--danger); margin-top: 0.25rem; display: flex; align-items: center; gap: 4px; }
        .btn-submit { margin-top: 1rem; width: 100%; padding: 1rem; background-color: var(--primary); color: white; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: background-color 0.2s ease; }
        .btn-submit:hover { background-color: var(--primary-hover); }
        
        @media (max-width: 640px) { nav { overflow-x: auto; white-space: nowrap; } .card { padding: 1.5rem; } }
    </style>
    <script>
        <c:if test="${not empty msg}">alert("${msg}");</c:if>
        document.addEventListener('DOMContentLoaded', () => {
            const dateInput = document.getElementById('startdate');
            if (!dateInput.value) {
                dateInput.value = new Date().toISOString().substring(0, 10);
            }
        });
    </script>
</head>
<body>
    <header>
        <div class="logo"><span>PARK SMART</span><span class="logo-badge">v1.0</span></div>
    </header>

    <nav>
        <a href="${pageContext.request.contextPath}/ticket/register.do" class="active">정기권 등록</a>
        <a href="${pageContext.request.contextPath}/ticket/list.do">정기권 조회</a>
        <a href="${pageContext.request.contextPath}/park/inout.do">입·출고 관리</a>
        <a href="${pageContext.request.contextPath}/park/status.do">주차 현황</a>
    </nav>

    <main>
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">정기권 등록</h2>
                <p class="card-subtitle">새로운 정기 차량 등록을 위한 정보를 입력해주세요.</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/ticket/register.do" method="post">
				
				
                <div class="form-grid">
                
                <div class="form-group">
				    <label for="nextTno">주차권 번호 (발급 예정)</label>
				    <input type="text" id="nextTno" 
				           value="NO. ${nextTno}" 
				           disabled 
				           style="background-color: #f1f5f9; color: #475569; font-weight: 700; cursor: not-allowed;">
				</div> </span>
                
                
                    <div class="form-group">
                        <label for="carno">차량 번호</label>
                        <input type="text" id="carno" name="carno" placeholder="예: 12가 3456" value="${param.carno}">
                        <c:if test="${errors.carno}"><span class="error-msg">⚠️ 차량번호를 정확히 입력하세요.</span></c:if>
                    </div>

                    <div class="form-group">
                        <label for="phone">차주 연락처</label>
                        <input type="text" id="phone" name="phone" placeholder="예: 010-1234-5678" value="${param.phone}">
                        <c:if test="${errors.phone}"><span class="error-msg">⚠️ 전화번호를 정확히 입력하세요.</span></c:if>
                    </div>

                    <div class="form-group">
                        <label for="grade">주차권 등급</label>
                        <select id="grade" name="grade">
                            <option value="D" ${param.grade == 'D' ? 'selected' : ''}>D : 일 주차 (+1일)</option>
                            <option value="M" ${param.grade == 'M' ? 'selected' : ''}>M : 월 주차 (+30일)</option>
                            <option value="Y" ${param.grade == 'Y' ? 'selected' : ''}>Y : 년 주차 (+365일)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="tstat">정기권 상태</label>
                        <select id="tstat" name="tstat">
                            <option value="Y" ${param.tstat == 'Y' ? 'selected' : ''}>Y : 주차 가능</option>
                            <option value="N" ${param.tstat == 'N' ? 'selected' : ''}>N : 주차 불가능</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="startdate">가입 일자</label>
                        <input type="date" id="startdate" name="startdate" value="${param.startdate}">
                        <c:if test="${errors.startdate}"><span class="error-msg">⚠️ 시작일을 선택하세요.</span></c:if>
                    </div>

                    <button type="submit" class="btn-submit">정기권 등록완료</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>