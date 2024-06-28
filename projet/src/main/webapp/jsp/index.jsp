<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Movie Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        .hero-section {
            height: 100vh;
            position: relative;
        }
        .carousel-item {
            height: 100vh;
            background-size: cover;
            background-position: center;
        }
        .overlay {
            background: rgba(0, 0, 0, 0.5);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .blur-effect {
            backdrop-filter: blur(5px);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .card-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 2;
            width: 90%;
            max-width: 400px;
            padding: 20px;
        }
        .card-title {
            text-align: center;
            font-size: 2rem;
            margin-bottom: 20px;
        }
        .card-text {
            text-align: center;
            font-size: 1.2rem;
            margin-bottom: 20px;
        }
        .btn-custom {
            margin: 0.5rem;
            width: 100%;
        }
    </style>
</head>
<body>
    <div id="carouselExampleIndicators" class="carousel slide hero-section" data-bs-ride="carousel" data-bs-interval="3000">
        <div class="carousel-inner">
            <%
                List<String> top5Movies = (List<String>) request.getAttribute("top5Movies");
                for (int i = 0; i < top5Movies.size(); i++) {
                    String moviePath = top5Movies.get(i);
                    String activeClass = (i == 0) ? "active" : "";
            %>
            <div class="carousel-item <%= activeClass %>" style="background-image: url('https://image.tmdb.org/t/p/original<%= moviePath %>')"></div>
            <%
                }
            %>
        </div>
        <div class="blur-effect"></div>
        <div class="overlay"></div>
        <div class="card card-overlay">
            <div class="card-body">
                <h1 class="card-title">Welcome to Movie Project</h1>
                <p class="card-text">Discover and track your favorite movies</p>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <p class="card-text">Welcome, ${sessionScope.user.email}!</p>
                        <a href="logout" class="btn btn-primary btn-custom">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login" class="btn btn-primary btn-custom">Login</a>
                        <a href="register" class="btn btn-secondary btn-custom">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script>
        var carousel = document.getElementById('carouselExampleIndicators');
        var bsCarousel = new bootstrap.Carousel(carousel, {
            interval: 3500
        });
    </script>
</body>
</html>
