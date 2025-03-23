package rt0805.projet.servlets.index;

import java.io.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import okhttp3.Request;
import okhttp3.Response;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "index", value = "/index")
public class IndexServlet extends HttpServlet {

    private static final String API_KEY = "42432b2be2cc68e61c83c78ab93cae39";

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        String apiUrl = "https://api.themoviedb.org/3/movie/popular?api_key=" + API_KEY + "&language=en-US&page=1";
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            JSONObject json = new JSONObject(content.toString());
            JSONArray results = json.getJSONArray("results");

            // Extract the top 5 movies
            List<String> top5Movies = IntStream.range(0, 5)
                    .mapToObj(i -> results.getJSONObject(i).getString("backdrop_path"))
                    .collect(Collectors.toList());

            // Set the movies as a request attribute
            request.setAttribute("top5Movies", top5Movies);
        } else {
            throw new IOException("Unexpected response code: " + responseCode);
        }

        // Forward to the view
        RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/index.jsp");
        dispatcher.forward(request, response);
    }
}