<%-- Created by IntelliJ IDEA. User: DRIOUCHE Date: 28/06/2024 Time: 16:07 To
change this template use File | Settings | File Templates. --%> <%@ page
import="org.json.JSONArray" %> <%-- Created by IntelliJ IDEA. User: DRIOUCHE
Date: 21/06/2024 Time: 15:15 To change this template use File | Settings | File
Templates. --%> <%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
prefix="fn" %> <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Détails du Film</title>
    <!-- Liens CSS Bootstrap -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    />
    <style>
      /* Styles personnalisés */
      body {
        background-color: #f8f9fa;
        color: #212529;
      }
      .movie-details {
        margin-top: 50px;
      }
      .movie-poster {
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      .movie-info {
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      .movie-title {
        font-size: 2.5rem;
        font-weight: bold;
        margin-bottom: 20px;
      }
      .movie-overview {
        font-size: 1.1rem;
        line-height: 1.6;
      }
      .rating {
        color: gold;
      }
    </style>
  </head>
  <body>
    <div class="container movie-details">
      <!-- Titre du film -->
      <h1 class="movie-title"><%= request.getAttribute("title") %></h1>

      <!-- Contenu principal -->
      <div class="row">
        <!-- Colonne pour l'image du film -->
        <div class="col-md-4">
          <% String posterPath = (String) request.getAttribute("posterPath");
          String title = (String) request.getAttribute("title"); String imageSrc
          = posterPath != null && !posterPath.isEmpty() ?
          "https://image.tmdb.org/t/p/w500" + posterPath :
          "https://via.placeholder.com/500x750.png?text=Image+Not+Available"; %>

          <img
            src="<%= imageSrc %>"
            class="img-fluid movie-poster"
            alt="<%= title %>"
          />

        </div>
        <!-- Colonne pour les informations du film -->
        <div class="col-md-8">
          <div class="movie-info">
            <!-- Informations sur le film -->
            <p>
              <strong>Date de sortie:</strong> <%=
              request.getAttribute("releaseDate") %>
            </p>
            <p>
              <strong>Langue:</strong> <%= request.getAttribute("language") %>
            </p>
            <p class="mb-4">
              <strong>Note moyenne:</strong> <%=
              request.getAttribute("voteAverage") %>/10 (<%=
              request.getAttribute("voteCount") %> votes)
            </p>

            <!-- Synopsis -->
            <h3>Synopsis</h3>
            <p class="movie-overview">
              <%= request.getAttribute("overview") %>
            </p>

            <!-- Ajouter d'autres détails si nécessaire -->
          </div>
        </div>
      </div>
    </div>

    <!-- Scripts Bootstrap -->
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
      crossorigin="anonymous"
    ></script>
  </body>
</html>
