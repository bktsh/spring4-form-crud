### How to convert a normal table to jquery dataTable
1. Dependencies/Pre-requisites
    1. Make sure you have added some JSON lib to your pom.xml to create your dataset object as JSON object:
    ~~~~~
    		<dependency>
    			<groupId>org.codehaus.jackson</groupId>
    			<artifactId>jackson-mapper-asl</artifactId>
    			<version>1.9.13</version>
    		</dependency>
    ~~~~~
    2. Make sure you have imported/included jQuery data table javascript library and jQuery library in your html files
    ~~~~~
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"> </script>
    ~~~~~
    3. Make sure third party libs(datatable bootstrap,bootstrap.css/.js) are included in your html
    ~~~~~
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" />
    <script src="//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
    <link href="https://cdn.datatables.net/1.10.15/css/dataTables.bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.datatables.net/1.10.15/js/dataTables.bootstrap.min.js"></script>
    ~~~~~

2. Make sure your list comes to client side as JSON, example:

 Convert this line:
 ~~~~
		model.addAttribute("users", userService.findAll());
 ~~~~
 To this lines:
 ~~~~
		ObjectMapper mapper = new ObjectMapper();
		model.addAttribute("users", mapper.writeValueAsString(userService.findAll()));
 ~~~~
3. Convert your JSP table to just have a unique user-friendly id as a place holder for your dataset:

Convert from this:
 ~~~~
		<table class="table table-striped">
			<thead>
				<tr>
					<th>#ID</th>
					<th>Name</th>
					<th>Email</th>
					<th>framework</th>
					<th>Action</th>
				</tr>
			</thead>

			<c:forEach var="user" items="${users}">
				<tr>
					<td>
						${user.id}
					</td>
					<td>${user.name}</td>
					<td>${user.email}</td>
					<td><c:forEach var="framework" items="${user.framework}" varStatus="loop">
						${framework}
    					<c:if test="${not loop.last}">,</c:if>
						</c:forEach></td>
					<td>
						<spring:url value="/users/${user.id}" var="userUrl" />
						<spring:url value="/users/${user.id}/delete" var="deleteUrl" />
						<spring:url value="/users/${user.id}/update" var="updateUrl" />

						<button class="btn btn-info" onclick="location.href='${userUrl}'">Query</button>
						<button class="btn btn-primary" onclick="location.href='${updateUrl}'">Update</button>
						<button class="btn btn-danger" onclick="this.disabled=true;post('${deleteUrl}')">Delete</button></td>
				</tr>
			</c:forEach>
		</table>
 ~~~~
 To this version:
 ~~~~
        <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="overflow-x:auto">
            <thead>
                <tr>
                    <th >#ID</th>
                    <th class="no-sort">Name</th>
                    <th class="no-sort">Email</th>
                    <th>framework</th>
                    <th class="no-sort">Action</th>
                </tr>
            </thead>
        </table>
 ~~~~
4. Add javascript snippet to your jsp page to make sure you populate your placeholder in the DOM with data:
 ~~~~
        <script type="text/javascript">
        $(document).ready(function(){
            var data  = eval('${users}');
            var table = $('#example').DataTable( {
                bProcessing: true,
                "aaData": data,
                'aoColumnDefs': [{
                        'bSortable': false,
                        'aTargets':  [ "no-sort" ], /* 1st colomn, starting from the right */
                }],
                "aoColumns": [
                    { "mData": "id"},
                    { "mData": "name"},
                    { "mData": "email"},
                    { "mData": "framework"},
                    {"render": function ( data, type, full, meta ) {
                          return '<a class="btn btn-xs btn-info" href="/users/'+full.id+'">view</a>';
                        }
                    }
                ],
                "paging":true
                });
            });
        </script>
 ~~~~
### How to install apache-http2 and connect it to tomcat using ajp!
#####Install Apache2

     1. wget http://mirrors.advancedhosters.com/apache//httpd/httpd-2.4.25.tar.bz2
     2. wget https://www.apache.org/dist/httpd/httpd-2.4.25.tar.bz2.md5
     3. md5sum -c httpd-2.4.25.tar.bz2.md5
     4. sudo apt-get install openssl libssl-dev
     5. sudo apt-get install libssl-dev
     6. sudo apt-get install zlib1g-dev
     7. sudo apt-get install libxml2-dev
     8. sudo apt-get install libapr1-dev libaprutil1-dev
     9. sudo apt-get install libpcre3 libpcre3-dev
     10. ./configure --prefix=/home/hashem/apache-2.4.25 --enable-mods-shared=all --enable-log_config=static --enable-access=static --enable-mime=static --enable-setenvif=static --enable-dir=static -enable-ssl=yes
#####Install Tomcat
     1. wget http://apache.mirrors.tds.net/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.zip
     2. wget https://www.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.zip.md5
     3. md5sum -c apache-tomcat-8.5.9.zip.md5
     4. unzip apache-tomcat-8.5.9.zip
     5. Install Mod_jk in tomcat: create workers.properties under config folder with following content:
~~~~~
    # Define 1 real worker named ajp13
    worker.list=ajp13
    # Set properties for worker named ajp13 to use ajp13 protocol,
    # and run on port 8009
    worker.ajp13.type=ajp13
    worker.ajp13.host=localhost
    worker.ajp13.port=8009
    worker.ajp13.lbfactor=50
    worker.ajp13.cachesize=10
    worker.ajp13.cache_timeout=600
    worker.ajp13.socket_keepalive=1
    worker.ajp13.socket_timeout=300
~~~~~

    1. Install Mod_JK inside apache2/conf/ “vim httpd.conf” add following:

~~~~~
    LoadModule jk_module modules/mod_jk.so
    JkWorkersFile /home/hashem/apache-tomcat-8.5.9/conf/workers.properties
    JkLogFile /home/hashem/apache-tomcat-8.5.9/logs/mod_jk.log
    JkLogLevel info
    JkLogStampFormat "[%a %b %d %H:%M:%S %Y]"
    JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories
    JkRequestLogFormat "%w %V %T"
    JkMount /tookan ajp13
    JkMount /tookan/* ajp13
~~~~~

Ref:
Spring example src: www.mkyong.com
