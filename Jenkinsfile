#!/usr/bin/env groovy
@Library('ares-lib') _

def dev = [ 
	"hostname": "3.232.239.122",
	"port": "50001",
	"external_alias": "build",
	"transport": "",
	"package": "",
	"software_component": "",
	"tfc_id": "",
	"build_phase": "",
	"credentials": "gCTS_source",
	"pipelinename": "",
  	"repo_id": "i079666gcts1",
  	"commit_id": "",
	"aunitresultKey": "AUNIT_1",
	"atcresultKey": "ATC_1"
]

def integrate = [ 
	"hostname": "34.228.253.201",
	"port": "50000",
	"external_alias": "build",
	"transport": "",
	"package": "",
	"software_component": "",
	"tfc_id": "",
	"build_phase" : "",
	"credentials": "gCTS_target",
	"pipelinename": "",
  	"repo_id": "i079666gcts1",
  	"commit_id": "",
	"aunitresultKey": "AUNIT_1",
	"atcresultKey": "ATC_1"
]



pipeline {
  agent any
  stages {
    stage('data declaration') {
      steps {
        script {
          dev.pipelinename = "${env.JOB_BASE_NAME}_${env.BUILD_NUMBER}"
          integrate.pipelinename = "${env.JOB_BASE_NAME}_${env.BUILD_NUMBER}"
          echoParameters(dev) 
          echoParameters(integrate)
          } //script
        } // steps
      } // stage
    stage('integrate') {
      steps {
        script {
          integrate.commit_id = sh(returnStdout: true, script: 'git rev-parse HEAD')
          echo 'integrate.commit_id is :'+integrate.commit_id 
          integrate.transport = pullByCommitgCTSHTTP(integrate)                  
          } //script
        } // steps
      } // stage
    stage('ATC checks') {
      parallel {    
        stage('AUNIT') {
	  steps {
	    script {
	      integrate.build_phase = "AUNIT"
	      callingBuildFrameworkHTTP(integrate)
	      getUnitTestResults(integrate)
	      } //script
	    } //steps
	  } //stage
	stage('ATC') {
	  steps {
	    script {
	      integrate.build_phase = "ATC"
	      callingBuildFrameworkHTTP(integrate)
	      getATCResults(integrate)
	      } //script
	    } //steps
	  } //stage
	} //parallel
      } //stage
    } //stages
  post {
    failure {
      script {
	echo "Build Failed"
	} //script
//      mail to: "andrey.sharapov@sap.com",
//      subject: "Error in CI pipeline",
//      body: "Something is wrong with build: ${env.RUN_DISPLAY_URL}"
      } //failure
    } //post
  } //pipeline
