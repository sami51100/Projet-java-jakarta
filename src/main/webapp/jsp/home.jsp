<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.json.JSONArray" %>
<%-- Created by IntelliJ IDEA. User: DRIOUCHE Date: 21/06/2024 Time: 15:15 To change this template use File | Settings | File Templates. --%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Movie Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        .container {
            margin-top: 20px;
        }
        .card {
            margin-bottom: 20px;
            cursor: pointer;
            height: 100%;
        }
        .card-img-top {
            height: 300px;
            object-fit: cover;
        }
        .card-body {
            text-align: center;
        }
        .truncate {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .rating {
            color: gold;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-link {
            cursor: pointer;
        }
        .filter-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .filter-container label {
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Films Populaires</h1>
            <div>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <p class="card-text">Welcome, ${sessionScope.user.email}!</p>
                        <a href="logout" class="btn btn-danger btn-custom">Logout</a>
                    </c:when>
                </c:choose>
            </div>
        </div>
        <form class="d-flex mb-4" method="get" action="home">
            <input class="form-control me-2" type="search" name="query" placeholder="Rechercher des films" aria-label="Rechercher">
            <button class="btn btn-outline-success" type="submit">Rechercher</button>
        </form>
        <form method="get" action="home">
          <div class="filter-container">
              <div class="btn-group-toggle" data-toggle="buttons">
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="27" autocomplete="off" ${param.genres == '27' ? 'checked' : ''}> Horreur
                  </label>
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="16" autocomplete="off" ${param.genres == '16' ? 'checked' : ''}> Animation
                  </label>
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="10749" autocomplete="off" ${param.genres == '10749' ? 'checked' : ''}> Romance
                  </label>
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="28" autocomplete="off" ${param.genres == '28' ? 'checked' : ''}> Action
                  </label>
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="35" autocomplete="off" ${param.genres == '35' ? 'checked' : ''}> Comédie
                  </label>
                  <label class="btn btn-outline-primary">
                      <input type="checkbox" name="genres" value="18" autocomplete="off" ${param.genres == '18' ? 'checked' : ''}> Drame
                  </label>
              </div>
              <button type="submit" class="btn btn-primary">Filtrer</button>
          </div>
      </form>           
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert alert-danger" role="alert">
            <%= error %>
        </div>
        <%
            }
        %>
        <div class="row row-cols-1 row-cols-md-4 g-4">
          <% 
              String tmdbMoviesStr = (String) request.getAttribute("tmdbMovies");
              if (tmdbMoviesStr != null && !tmdbMoviesStr.isEmpty()) {
                  JSONArray tmdbMovies = new JSONArray(tmdbMoviesStr);
                  for (int i = 0; i < tmdbMovies.length(); i++) {
                      JSONObject movie = tmdbMovies.getJSONObject(i);
                      String posterPath = movie.isNull("poster_path") ? "" : movie.getString("poster_path");
          %>
          <div class="col">
              <a href="/projet-1.0-SNAPSHOT/moviedetails?id=<%= movie.getInt("id") %>"> <!-- Modification ici -->
                  <div class="card">
                      <% if (!posterPath.isEmpty()) { %>
                          <img src="https://image.tmdb.org/t/p/w500<%= posterPath %>" class="card-img-top" alt="<%= movie.getString("title") %>">
                      <% } %>
                      <div class="card-body">
                          <h5 class="card-title truncate"><%= movie.getString("title") %></h5>
                          <p class="card-text truncate"><%= movie.getString("overview").length() > 100 ? movie.getString("overview").substring(0, 100) + "..." : movie.getString("overview") %></p>
                          <div class="rating">
                              <%
                                  double voteAverage = movie.getDouble("vote_average");
                                  int fullStars = (int) voteAverage / 2;
                                  for (int j = 0; j < fullStars; j++) {
                                      out.print("&#9733;");
                                  }
                                  for (int j = fullStars; j < 5; j++) {
                                      out.print("&#9734;");
                                  }
                              %>
                          </div>
                      </div>
                  </div>
              </a>
          </div>
          <% 
                  }
              }
          %>
      </div>
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    if (currentPage != null && totalPages != null) {
                        int maxDisplayPages = 10;
                        int startPage = Math.max(1, currentPage - maxDisplayPages / 2);
                        int endPage = Math.min(totalPages, currentPage + maxDisplayPages / 2);

                        // Affichage des liens vers la première page et des points de suspension si nécessaire
                        if (startPage > 1) {
                %>
                            <li class="page-item">
                                <a class="page-link" href="home?page=1">1</a>
                            </li>
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                <%
                        }

                        // Affichage des pages numérotées
                        for (int i = startPage; i <= endPage; i++) {
                %>
                            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="home?page=<%= i %>"><%= i %></a>
                            </li>
                <%
                        }

                        // Affichage des points de suspension et du lien vers la dernière page si nécessaire
                        if (endPage < totalPages) {
                %>
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>

                            <li class="page-item">
                              <span class="page-link"><%= totalPages %></span>
                            </li>
                <%
                        }
                    }
                %>
            </ul>
        </nav>      
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
