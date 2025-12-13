	# Utiliser une image Java 17 officielle
FROM eclipse-temurin:17-jdk-alpine

# Copier le jar construit par Maven
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port sur lequel tourne l'application
EXPOSE 8080

# Commande pour lancer l'application
ENTRYPOINT ["java","-jar","/app.jar"]

