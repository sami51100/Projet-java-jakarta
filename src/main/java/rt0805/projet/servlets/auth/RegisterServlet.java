package rt0805.projet.servlets.auth;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import okhttp3.Request;
import okhttp3.Response;
import org.mindrot.jbcrypt.BCrypt;
import org.xml.sax.SAXException;
import rt0805.projet.dao.DbManager;

import javax.xml.parsers.ParserConfigurationException;

@WebServlet(name = "auth.register", value = "/register")
public class RegisterServlet extends HttpServlet {
    private Connection db ;
    @Override
    public void init () throws ServletException {
        super.init();
        db = DbManager.getConnection();
    }

    @Override
    public void destroy () {
        super.destroy();
        DbManager.closeConnection(db);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        response.setContentType("text/html");

        // Renvoyer vers la vue index.jsp pour afficher les films de l'utilisateur
        RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/auth/register.jsp");
        dispatcher.forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (createUser(email, password, request, response) > 0) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/auth/login.jsp");
            dispatcher.forward(request, response);
        } else {
            request.getSession().setAttribute("errorMessage", "Registration failed. Please try again.");
            response.sendRedirect("register");
        }

    }

    private int createUser(String email, String password, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String sql = "INSERT INTO user (email, password) VALUES (?, ?)";
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        try (PreparedStatement ps = db.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            return ps.executeUpdate();
        } catch (SQLIntegrityConstraintViolationException e) {
            request.getSession().setAttribute("errorMessage", "The email is already in use.");
            response.sendRedirect("register");

        }catch (SQLException e) {
            e.printStackTrace();

        }
        return 0;
    }

}