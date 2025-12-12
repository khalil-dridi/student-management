pipeline {
    agent any

    tools {
        maven 'M2_HOME'    // Nom de ton Maven installé sur Jenkins
        jdk 'JAVA_HOME'    // Nom de ton JDK installé sur Jenkins
    }

    environment {
        // Ces variables seront liées à tes credentials Jenkins pour Docker Hub
        DOCKER_HUB_CREDENTIALS = 'dockerhub-cred'  // ID de tes credentials Jenkins
        DOCKER_IMAGE_NAME = 'khalildridi9/student-management' // Nom de ton repo Docker Hub
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Récupération du code depuis Git...'
                git branch: 'main', url: 'https://github.com/khalil-dridi/student-management.git'
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Compilation et exécution des tests avec le profil test...'
                sh './mvnw clean install -Dspring.profiles.active=test'
            }
        }

        stage('Collect Test Results') {
            steps {
                echo 'Récupération des résultats de tests pour Jenkins...'
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construction de l\'image Docker...'
                sh "docker build -t ${DOCKER_IMAGE_NAME}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Connexion à Docker Hub et push de l\'image...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}",
                                                  usernameVariable: 'DOCKER_USERNAME',
                                                  passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                    docker push ${DOCKER_IMAGE_NAME}:latest
                    '''
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh "mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=student-management \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN"
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline terminée avec succès ✅'
        }
        failure {
            echo 'Pipeline échouée ❌'
        }
    }
}
