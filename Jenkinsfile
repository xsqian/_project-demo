pipeline {
   agent any
    environment {
      RELEASE='20.04'
    }
   stages {
      stage('Build') {
            environment {
               LOG_LEVEL='INFO'
            }
            agent {
                docker {
                    image 'mlrun/mlrun:1.0.0' 
                }
            }
            steps {
               echo "Building release ${RELEASE} with log level ${LOG_LEVEL}..."
               sh 'chmod +x build.sh'
               withCredentials([string(credentialsId: 'an-api-key', variable: 'API_KEY')]) {
                  sh '''
                     ./build.sh
                  '''
               }
               sh 'python --version' 
               sh 'pip list | grep mlrun'
            }
        }
        stage('Test') {
            steps {
               echo "Testing release ${RELEASE}"
               script {
                  if (Math.random() > 0.99) {
                     throw new Exception()
                  }
               }
               writeFile file: 'test-results.txt', text: 'passed'               
            }
        }
   }
   post {
      success {
         archiveArtifacts 'test-results.txt'
         slackSend channel: '#builds',
                   color: 'good',
                   message: "Release ${env.RELEASE}, success: ${currentBuild.fullDisplayName}."
      }
      failure {
         slackSend channel: '#builds',
                   color: 'danger',
                   message: "Release ${env.RELEASE}, FAILED: ${currentBuild.fullDisplayName}."
      }
   }
}