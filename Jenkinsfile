node {
    // Clean workspace before doing anything
    deleteDir()

    try {
        stage ('Prepare:Environment') {
          checkout scm
        }
        stage ('Download execution packages') {
          sh 'mkdir ~/archives'
          sh 'wget -P ~/archives/ http://jmp.sh/T3cvkjz'
          sh 'wget -P ~/archives/ http://jmp.sh/7hr9Ckp'
        }
        stage ('Execute scripts') {
          // sh 'ansible-galaxy -r jenkins-test-requirements.yml -p roles/ install'
          sh './master-installer.sh -a sample-1.1-SNAPSHOT -t w1h1'
        }
    } catch (err) {
        currentBuild.result = 'FAILED'
        throw err
    }
}
