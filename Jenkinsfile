pipeline {
    agent any

    triggers {
        githubPush()  // Trigger on GitHub push (make sure webhook is configured)
    }

    environment {
        LOCAL_SERVER = 'tcp:10.128.0.16,1433'
        REMOTE_SERVER = 'tcp:10.128.0.19,1433'
        LOCAL_DB = 'aspnet_DB'
        REMOTE_DB = 'aspnet_DB'
        LOCAL_TABLE = 'asp_user'
        REMOTE_TABLE = 'asp_user'
        SA_USER = 'sa'
        SA_PASS = 'P@ssword@123'  // Ideally use Jenkins credentials store for this
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/SrikarVanaparthy/VM-to-VM-.git', branch: 'main'
            }
        }

        stage('Run PowerShell Script') {
            steps {
                powershell """
                    Set-ExecutionPolicy Bypass -Scope Process -Force
                    .\\migrate-users.ps1 `
                        -LocalServer '$env:LOCAL_SERVER' `
                        -RemoteServer '$env:REMOTE_SERVER' `
                        -LocalDB '$env:LOCAL_DB' `
                        -RemoteDB '$env:REMOTE_DB' `
                        -LocalTable '$env:LOCAL_TABLE' `
                        -RemoteTable '$env:REMOTE_TABLE' `
                        -User '$env:SA_USER' `
                        -Password '$env:SA_PASS'
                """
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
