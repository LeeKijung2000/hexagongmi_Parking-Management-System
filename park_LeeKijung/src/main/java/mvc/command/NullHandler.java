package mvc.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException; // IOException 추가
import javax.servlet.ServletException; // ServletException 추가

public class NullHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) 
            throws IOException, ServletException { // 예외 처리 선언 추가
        
        res.sendError(HttpServletResponse.SC_NOT_FOUND);
        return null;
    }
}