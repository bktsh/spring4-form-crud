<%@ page session="false"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../fragments/header.jsp" />
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

<body>
	<div class="container">
		<c:if test="${not empty msg}">
			<div class="alert alert-${css} alert-dismissible" role="alert">
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<strong>${msg}</strong>
			</div>
		</c:if>
		<h4>All Users</h4>
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
	</div>
	<jsp:include page="../fragments/footer.jsp" />

</body>
</html>