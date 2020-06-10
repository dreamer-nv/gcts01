#!/usr/bin/env groovy

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
	"aunitresultKey": "AUNIT_FOR_TCK",
	"atcresultKey": "ATC_FOR_TCK"
]

def integrate = [ 
	"hostname": "34.228.253.201",
	"port": "50001",
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
	"aunitresultKey": "AUNIT_FOR_TCK",
	"atcresultKey": "ATC_FOR_TCK"
]

def echoParameters(Map args) {
	/*args.each{
	  echo "${args.key} = ${args.value}"
	}*/
	echo "Hostname = ${args.hostname}"
	echo "Port = ${args.port}"
	echo "Service = ${args.external_alias}"
	echo "TFC_ID = ${args.tfc_id}"
	echo "Transport = ${args.transport}"
	echo "Mail = ${args.mail}"
}

def pullByCommitgCTSHTTP(Map args) {

    echo "Inside pullByCommit Function"
    def trkorr = ""
    def toolURL = 'http://'+args.hostname+':'+args.port+'/sap/bc/cts_abapvcs/repository/'+args.repo_id+'/pullByCommit?request='+args.commit_id
    echo 'tool url : '+toolURL	
    String ABAPURL = toolURL.toURL()
    def resultJSON = 'results/ABAP_'+args.hostname+'_gCTS_result_'+env.BUILD_NUMBER+'.json'
    def resp = httpRequest authentication: args.credentials, url: ABAPURL, outputFile: resultJSON
    echo 'gCTS PullByCommit Log : '+ resp.content
    try{
	    def gCTSMap = new groovy.json.JsonSlurper().parseText(resp.content)
	    trkorr = gCTSMap.trkorr
     } 
     catch (exc)
      {
         echo 'xml parser failed'
         echo 'exception : '+exc
      }
     
    echo 'trkorr is :'+ trkorr
    if (trkorr == null)
    {
      echo 'No new changes to ABAP objects'
      currentBuild.result = 'FAILURE'
      error "trkorr is null"
    }
    return trkorr
}

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
          }
        }
      }
    stage('integrate') {
      steps {
        script {
          integrate.commit_id = sh(returnStdout: true, script: 'git rev-parse HEAD')
          echo 'integrate.commit_id is :'+integrate.commit_id 
          integrate.transport = pullByCommitgCTSHTTP(integrate)                  
          }
        }
      }    
    }
  }
