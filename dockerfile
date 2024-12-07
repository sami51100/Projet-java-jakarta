# Utiliser une image de base pour Java
FROM openjdk:17-jdk-slim

# Ajouter le fichier WAR généré dans le conteneur
COPY target/projet-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

# Exposer le port de l'application (par exemple, Tomcat utilise généralement 8080)
EXPOSE 8080

# Commande pour démarrer l'application
CMD ["java", "-jar", "/usr/local/tomcat/webapps/projet-1.0-SNAPSHOT.war"]