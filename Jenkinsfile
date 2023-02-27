pipeline{
    agent any

    stages{

        stage('Build'){
            steps{
                script {
                   sh 'chmod +x gradlew'
                   sh './gradlew clean build'
                }
            }
        }

       stage('Test Execution'){
           steps{
               script {
                  sh './gradlew test --tests BookingRunner'
               }
           }
       }
    }

    post {
       always {
            publishHTML target: [
               allowMissing: false,
               alwaysLinkToLastBuild: false,
               keepAll: true,
               reportDir: 'build/reports/tests/test',
               reportFiles: 'index.html',
               reportName: 'Api Test Yape Report-'
             ]
       }
   }
}
