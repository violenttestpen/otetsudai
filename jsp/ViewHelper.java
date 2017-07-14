package helper;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public final class ViewHelper {
    public static void loadView(HttpServletRequest request, HttpServletResponse response, String urlpath)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher(urlpath);
        rd.forward(request, response);
    }
    
    public static void redirectTo(HttpServletResponse response, String urlpath) throws IOException {
        response.sendRedirect(urlpath);
    }
}
