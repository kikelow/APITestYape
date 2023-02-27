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

       stage('Test'){
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
               reportDir: 'target/karate-reports',
               reportFiles: 'karate-summary.html',
               reportName: 'Api Test Yape Report-'
             ]
       }
   }
}
