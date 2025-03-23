package rt0805.projet.servlets.index;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "home", value = "/home")
public class TMDBServlet extends HttpServlet {

    private static final String API_KEY = "42432b2be2cc68e61c83c78ab93cae39";
    private static final String TMDB_API_URL = "https://api.themoviedb.org/3/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String query = request.getParameter("query");
        String page = request.getParameter("page");
        String[] genres = request.getParameterValues("genres");

        StringBuilder urlString = new StringBuilder(TMDB_API_URL);

        if (query != null && !query.isEmpty()) {
            urlString.append("search/movie?query=").append(URLEncoder.encode(query, "UTF-8")).append("&api_key=")
                    .append(API_KEY);
        } else if (genres != null && genres.length > 0) {
            urlString.append("discover/movie?api_key=").append(API_KEY);

            // Construction du filtre par genres
            String genreFilter = String.join(",", genres);
            urlString.append("&with_genres=").append(genreFilter);
        } else {
            urlString.append("movie/popular?api_key=").append(API_KEY);
        }

        urlString.append("&page=").append(page != null ? page : "1");

        HttpURLConnection conn = null;
        try {
            URL url = new URL(urlString.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder responseBuilder = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                responseBuilder.append(line);
            }
            in.close();

            JSONObject jsonObject = new JSONObject(responseBuilder.toString());
            JSONArray results = jsonObject.getJSONArray("results");

            request.setAttribute("tmdbMovies", results.toString());
            request.setAttribute("currentPage", jsonObject.getInt("page"));
            request.setAttribute("totalPages", jsonObject.getInt("total_pages"));
            request.getRequestDispatcher("jsp/home.jsp").forward(request, response);

        } catch (IOException e) {
            request.setAttribute("error", "Erreur lors de la récupération des données depuis TMDB: " + e.getMessage());
            request.getRequestDispatcher("jsp/home.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}
