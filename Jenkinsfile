pipeline {
    agent any
    stages {
        stage('Echo') {
            steps {
                echo "Executing ${env.BUILD_ID} on ${env.JENKINS_URL}"
            }
        }
    }
}