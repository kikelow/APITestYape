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
               reportDir: 'build/karate-reports',
               reportFiles: 'booking.test.Authentications.html',
               reportName: 'Feature Authentications Report'
             ]
             publishHTML target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'build/karate-reports',
                reportFiles: 'booking.test.BookingOperations.html',
                reportName: 'BookingOperations Report'
              ]
              publishHTML target: [
                 allowMissing: false,
                 alwaysLinkToLastBuild: false,
                 keepAll: true,
                 reportDir: 'build/karate-reports',
                 reportFiles: 'booking.test.CheckHealth.html',
                 reportName: 'CheckHealth Report'
               ]
       }
   }
}
