# Étape 1 : build Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Étape 2 : image avec WildFly
FROM jboss/wildfly:latest
# FROM quay.io/wildfly/wildfly:30.0.1.Final
# FROM jboss/wildfly:27.0.1.Final


# Copie du .war généré dans le répertoire de déploiement
COPY --from=build /app/target/projet-1.0-SNAPSHOT.war /opt/jboss/wildfly/standalone/deployments/projet.war

# Port HTTP
EXPOSE 8080

# Lancement WildFly
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]