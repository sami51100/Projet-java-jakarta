package rt0805.projet.servlets.auth;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.mindrot.jbcrypt.BCrypt;
import rt0805.projet.dao.DbManager;
import rt0805.projet.model.User;

@WebServlet(name = "auth.login", value = "/login")
public class LoginServlet extends HttpServlet {
    private Connection db;

    @Override
    public void init() throws ServletException {
        super.init();
        db = DbManager.getConnection();
    }

    @Override
    public void destroy() {
        super.destroy();
        DbManager.closeConnection(db);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");
        RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/auth/login.jsp");
        dispatcher.forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = authenticateUser(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("errorMessage", "Invalid email or password.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/auth/login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/auth/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private User authenticateUser(String email, String password) throws SQLException {
        String sql = "SELECT id, email, password FROM user WHERE email = ?";
        try (PreparedStatement ps = db.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (BCrypt.checkpw(password, storedPassword)) {
                        return new User(rs.getInt("id"), rs.getString("email"));
                    }
                }
            }
        }
        return null;
    }


}
