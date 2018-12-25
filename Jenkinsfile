pipeline {
    agent any
    stages {
        stage('Echo') {
            steps {
                echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            }
        }
    }
}