pipeline {
    agent any

    tools {
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-cred'
        DOCKER_IMAGE_NAME = 'khalildridi9/student-management'
        K8S_NAMESPACE = 'devops'
        SPRING_SERVICE_NAME = 'spring-service'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/khalil-dridi/student-management.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh './mvnw clean install -Dspring.profiles.active=test'
            }
        }

        stage('Collect Test Results') {
            steps {
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE_NAME}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
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
                echo 'Analyse SonarQube...'
                withSonarQubeEnv('sonarqube-server') {
                    withCredentials([string(credentialsId: 'SONAR_AUTH_TOKEN', variable: 'SONAR_AUTH_TOKEN')]) {
                        sh """
                            ./mvnw sonar:sonar \
                                -Dsonar.projectKey=student-management \
                                -Dsonar.host.url=$SONAR_HOST_URL \
                                -Dsonar.login=$SONAR_AUTH_TOKEN
                        """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Déploiement sur Kubernetes...'
                sh """
                    kubectl set image deployment/student-spring app=${DOCKER_IMAGE_NAME}:latest -n devops
                    kubectl rollout status deployment/student-spring -n devops
                """
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
