pipeline {
    agent any

    tools {
        maven 'M2_HOME'    // Nom de ton Maven installé sur Jenkins
        jdk 'JAVA_HOME'       // Nom de ton JDK installé sur Jenkins
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
