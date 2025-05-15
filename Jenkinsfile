pipeline {
    agent any

    triggers {
        githubPush()  // Trigger pipeline on GitHub push
    }

    environment {
        SCRIPT_FILE = 'migrate-users.ps1'
    }



    stages {


        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/SrikarVanaparthy/VM-to-VM-.git', branch: 'main'
            }
        }


        stage('Run PowerShell Script') {
            steps {
                powershell '''
                    Set-ExecutionPolicy Bypass -Scope Process -Force
                    .\\migrate-users.ps1
                '''
            }
        }

    }

    post {
        success {
            echo '✅ Migration job completed successfully.'
        }
        failure {
            echo '❌ Migration job failed.'
        }
    }
}
