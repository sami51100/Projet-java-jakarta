package rt0805.projet.servlets.movie;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet(name = "moviedetails", value = "/moviedetails")
public class MovieDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String API_KEY = "42432b2be2cc68e61c83c78ab93cae39";
    private static final String TMDB_API_URL = "https://api.themoviedb.org/3/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieId = request.getParameter("id");

        if (movieId != null && !movieId.isEmpty()) {
            try {
                // Construire l'URL de l'API TMDB pour récupérer les détails du film
                String apiUrl = TMDB_API_URL + "movie/" + URLEncoder.encode(movieId, StandardCharsets.UTF_8)
                        + "?api_key=" + API_KEY;

                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.connect();

                // Lire la réponse JSON de l'API
                InputStream inputStream = conn.getInputStream();
                InputStreamReader reader = new InputStreamReader(inputStream, StandardCharsets.UTF_8);

                StringBuilder sb = new StringBuilder();
                int cp;
                while ((cp = reader.read()) != -1) {
                    sb.append((char) cp);
                }

                // Convertir la réponse JSON en objet JSONObject
                JSONObject jsonObject = new JSONObject(sb.toString());

                // Extraire les informations nécessaires du JSON
                String title = jsonObject.getString("title");
                String releaseDate = jsonObject.getString("release_date");
                String language = jsonObject.getString("original_language");
                String overview = jsonObject.getString("overview");
                double voteAverage = jsonObject.getDouble("vote_average");
                int voteCount = jsonObject.getInt("vote_count");
                String posterPath = jsonObject.getString("poster_path");

                // Mettre les détails du film en attributs de requête pour la JSP
                request.setAttribute("title", title);
                request.setAttribute("releaseDate", releaseDate);
                request.setAttribute("language", language);
                request.setAttribute("overview", overview);
                request.setAttribute("voteAverage", voteAverage);
                request.setAttribute("voteCount", voteCount);
                request.setAttribute("posterPath", posterPath);

                // Rediriger vers la page de détails du film (movieDetails.jsp)
                request.getRequestDispatcher("/jsp/movie/movieDetails.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Erreur : " + e.getMessage());
            }
        } else {
            response.getWriter().println("ID du film non spécifié");
        }
    }
}