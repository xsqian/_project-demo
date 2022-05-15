pipeline {
   agent any
    environment {
      RELEASE='20.04'
    }
   stages {
      stage('Audit tools') {
         steps{
            auditTools()
         }
      }
      stage('Build') {
            environment {
               LOG_LEVEL='INFO'
               MLRUN_DBPATH='https://mlrun-api.default-tenant.app.aaa-spark-fs.iguazio-cd2.com'
               V3IO_ACCESS_KEY=credentials('V3IO_ACCESS_KEY')
               V3IO_USERNAME='xingsheng'
               V3IO_API="https://default-tenant.app.aaa-spark-fs.iguazio-cd2.com:8443"
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

void auditTools() {
   sh '''
      git version
      docker version
      pip list | grep mlrun
   '''
}