var https = require('https')
var fs = require('fs')

var options= {
	key : fs.readFileSync('ssh_key.pem'),
	cert: fs.readFileSync('ssh_cert.pem')
}

https.creatServer(options,function(req,res){
	res.writeHead(200)
	res.end('Hello Immoc')
})
.listen(8090)