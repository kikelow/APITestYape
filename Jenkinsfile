pipeline{
    agent any

    stages{

            stage('Checkout SCM'){
                steps{
                    checkout scm
                }
            }

        stage('Build'){
            steps{
                echo 'Building...'
            }
        }

       stage('Test'){
           steps{
               echo 'Test...'
           }
       }

       stage('Report'){
           steps{
               echo 'Report...'
           }
       }
    }


}
