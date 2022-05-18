pipeline {
   agent any
    environment {
      RELEASE='1.0.0'
    }
   stages {
      stage('Audit tools') {
         steps{
            auditTools()
         }
      }
      stage('Build') {
            environment {
               PROJECT_NAME='project-demo'
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
               echo "Building release ${RELEASE} for project ${PROJECT_NAME}..."
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
               echo "Testing release ${RELEASE}, this is a fake test to mimic failure"
               script {
                  if (Math.random() > 0.99) {
                     throw new Exception()
                  }
               }
            }
        }
   }
   post {
      success {
         slackSend channel: '#builds',
                   color: 'good',
                   message: "Project ${PROJECT_NAME}, success: ${currentBuild.fullDisplayName}."
      }
      failure {
         slackSend channel: '#builds',
                   color: 'danger',
                   message: "Project ${PROJECT_NAME}, FAILED: ${currentBuild.fullDisplayName}."
      }
   }
}

void auditTools() {
   sh '''
      git version
      docker version
   '''
}