pipeline {
    agent any
    stages {
        stage('Load') {
            steps {
                sh 'git clean -f -d'
                sh 'rm -rf pharo-local/*'
                sh 'chmod +x build/*.sh'
                sh 'build/load.sh'
            }
        }
        stage('Run examples') {
            steps {
                sh 'build/test.sh'
                junit '*.xml'
            }
        }
        stage('Build gtoolkit') {
            steps {
                build '/gtoolkit'
                echo "gtoolkit build done."
            }
        }
    }
}