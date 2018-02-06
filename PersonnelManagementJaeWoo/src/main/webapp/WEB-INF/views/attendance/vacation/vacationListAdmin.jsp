<!-- 
	휴가조회(관리자) - 유성실,신지연
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dth">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>휴가조회(관리자)</title>
<link type="text/css" rel="stylesheet" href="/spring/resources/common/css/vacation.css" />
<!-- <link type="text/css" rel="stylesheet" href="/spring/resources/common/css/theme.default.css" /> -->
<!-- <script src="/spring/resources/common/js/jquery-latest.min.js"></script> -->
<!-- <script src="/spring/resources/common/js/jquery.tablesorter.widgets.js"></script> -->
<!-- <script src="/spring/resources/common/js/excelExportJs.js"></script> -->
<script>

$(function(){
	calender();		//달력함수
	deptSelect();	//부서 셀렉 
	vacEmpList();	//사원 리스트 함수 AJAX
	rankSelect();	//직급 셀렉
});
	

/* 휴가 조회 리스트  ajax */
		
function vacEmpList(){

	paging.ajaxFormSubmit("vacationListAdmin.ajax", "vacListAdminFrm", function(rslt){
		console.log("ajaxFormSubmit -> callback");
		console.log("결과데이터:"+JSON.stringify(rslt));
		
		//이전 리스트 삭제
		$('#deptNameList').empty();	//부서 셀렉박스
		$('#rankNameList').empty();	//직급 셀렉박스
		$('#vacListTbody').empty();	//사원 리스트
		
		//테이블 스크롤 CSS
		$('#vacListTable').children('thead').css('width','calc(100% - 1.1em)');
		
	
		//부서명 셀렉박스
		if(rslt.deptNameList == null){
			$('#deptNameList').append("<option value=''>"+ 없음  +"</option>");
		} else {
			$('#deptNameList').append(
				"<option value=''>"+ '부서' +"</option>");
			$.each(rslt.deptNameList, function(k, v){
				$('#deptNameList').append(
					"<option value='"+v.deptCode+"'>"+ v.deptName +"</option>"	
				);
			});//.each.deptName
			$('#deptNameList').val($('#selectTestName').val()).prop("selected", true); //input hidden값 value를 선택
		}//if

		
		//직급명 셀렉박스
		if(rslt.rankNameList == null){
			$('#rankNameList').append("<option value=''>"+ 없음  +"</option>");
		} else {
			$('#rankNameList').append(
				"<option value=''>"+ '직급' +"</option>");
			$.each(rslt.rankNameList, function(k, v){
				$('#rankNameList').append(
					"<option value='"+ v.rankCode +"'>"+ v.rankName + "</option>"		
				);
			});//each.rankName
			
		}//if
		
		
		//사원 휴가 리스트
		if(rslt.vacationList == null){
			$('#vacListTbody').append(
				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"	
			);
		} else {
			$.each(rslt.vacationList, function(k, v){
				$('#vacListTbody').append(
					"<tr data-toggle='modal' data-target='#myModal' id='"+v.empEmno+"' onclick='empVacationList("+JSON.stringify(v.empEmno)+")'>"+
						"<td>"+ v.retrDelYn +"</td>"+	//재직구분
						"<td>"+ v.empEmno +"</td>"+ //사원번호
						"<td>"+ v.empName +"</td>"+ //사원명
						"<td>"+ v.deptName +"</td>"+ //부서명
						"<td value='"+v.rankCode+"'>"+ v.rankName +"</td>"+ //직급명
						"<td>"+ v.emreVacCnt +"</td>"+ //휴가 전체 일수
						"<td>"+ v.emrePvacUd +"</td>"+ //휴가 사용 일수
						"<td>"+ v.remineVacCnt +"</td>"+	//휴가 잔여일수
					"</tr>"
				);
			});//each list

			
			//테이블 내용 가운데 정렬	
			$('#vacListTable').children().addClass('text-center');	
			//테이블 sort
			$(function(){
				$('#vacListTable').tablesorter();
			});
			$(function(){
				$('#vacListTable').tablesorter({sortList: [[0,0], [1,0]]});
			});
				
		}//if-table 생성

		//테이블 마우스오버시 (행을 지날 때), 색 바뀜
// 		$(document).ready(function(){
			$('table tbody tr').mouseover(function(){ 
				$(this).css("backgroundColor","#f2f2f2"); 
				$(this).click(function(){
					$(this).css("backgroundColor","#88C9DF");
				});
			}); 
			$('table tr').mouseout(function(){ 
				$(this).css("backgroundColor","#fff"); 
			});
	});//paging		
};	// vacationAdemin List : END
	
/*검색 버튼 */
function searchClick(){		
	vacEmpList();
};

/* 부서명 셀렉 */
function deptSelect(){
	$("#deptNameList").change(function(){
		
		//input hidden의 vlaue로 선택한 option을 입력
		$('#selectTestName').val($(this).children("option:selected").select().val()); 
		vacEmpList(); //ajax 실행
	});
}
	
/* 직급명 셀렉 */
function rankSelect(){
	$('#rankNameList').change(function(){
		$(this).children("option:selected").text();	
		console.log("dddddddddddddddddddddd"+$(this).children("option:selected").text());
		vacEmpList();
	});
}


	
	
	

/* 검색어 입력 후 엔터키 작동 - 아직 안됨 */
function press(f){
	if(f.keyCode == 13){	//javaScript에서는 13이 enter키를 의미함
		vacListAdminFrm.submit();
	}
}


/* 년도 달력 */
function calender(){
	$('#baseYear').val(moment().format('YYYY'));	//올해 년도 보여줌
	$('#yearDateTimePicker').datetimepicker({
		viewMode: 'years',
		format: 'YYYY'
	});
	
	//년도의 최대값을 올해로 제한
	$('#yearDateTimePicker').data("DateTimePicker").maxDate(moment());
};	
	

/* 휴가신청현황 페이지로 이동 */
function vacationProgressList() {
	window.location.href = "${pageContext.request.contextPath}/vacationProgressList";
}

/* 휴가 신청현황 개수 표시 */
$(function() {
	paging.ajaxSubmit("vacationProgCntNum.ajax", "", function(rslt) {
		console.log("ajaxFormSubmit -> callback");
		console.log("결과데이터:" + JSON.stringify(rslt));
		$("#countNum").html(rslt);
	});
});




/*모달 리스트 START */
$(function(){
// 	$("input[type=hidden][name=empEmno]").val();	//사원번호
		empVacationList();	//사원 휴가 사용 내역 ajax
		$('#empVacListTable').children().addClass('text-center'); //테이블 내용 가운데 정렬
});

//테이블 정렬
function tablesorterFunc(){
	$('#empVacListTable').tablesorter();
	$('#empVacListTable').tablesorter({sorterList: [[0,0],[1,0]]});
}


//휴가 신청 내역 ajax start
function empVacationList(empEmno){
	$('#empEmno').val(empEmno);	
	console.log(empEmno);
	
	paging.ajaxFormSubmit("empVacationList.ajax", "empVacFrm", function(rslt){
		console.log("ajaxFormSubmit -> callback");
		console.log("결과데이터:"+JSON.stringify(rslt));
		
		//테이블 스크롤 CSS
		$('#empVacListTable').children('thead').css('width','calc(100% - 1.1em)');
		$('#empVacListTbody').empty();	//이전 리스트 삭제
		//리스트가 없을 경우
		if(rslt == null || rslt.success == "N"){
			$('#empVacListTbody').append(
				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"		
			);
		//리스트가 있을 경우	
		} else if(rslt.success == "Y"){
			//상단 사원 정보
			$.each(rslt.empInfo, function(k, v){
				//$('#empEmno').text($("input[type=hidden][name=empEmno]").val()); //히든:사원번호
				$('#empInfoH').html('[' + v.deptName + ']' + '&nbsp;' + v.empName + '&nbsp;' + v.rankName + '&nbsp;' + "휴가 현황");
			});	//each.empInfo
			
			//휴가 현황 정보 리스트
			var i = 1;
			$.each(rslt.empVacList, function(k, v){	
				$('#empVacListTbody').append(
					"<tr>"+
	 					"<td>"+ i +"</td>"+ //번호
	 					"<td>"+ v.vastCrtDate +"</td>"+	//휴가신청날짜
	 					"<td>"+ v.vastType +"</td>"+	//휴가명
	 					"<td>"+ v.vastTerm +"</td>"+	//휴가기간
	 					"<td>"+ v.vastVacUd +"</td>"+	//사용개수
	 					"<td>"+ v.vastCont +"</td>"+	//휴가 사유
 					"</tr>"
				);//append Tbody
				i++;	//번호 1씩 증가
			});//each.empVacList

			//휴가 개수 
			$.each(rslt.empVacNum, function(k, v){
				$('#empVacListTbody').append(
					"<th colspan='2' class='text-center' id='vacationNumTh'>" + '합계' + "</th>" +
					"<th colspan='5'>" +
						"·총 휴가일수:" +"&nbsp;"+ v.emreVacCnt +"&nbsp;&nbsp;" +	//휴가 전체 일수
						"·사용일수:" +"&nbsp;"+ v.emrePvacUd +"&nbsp;&nbsp;" +	//사용 일수
						"·잔여일수:" +"&nbsp;"+ v.remineVacCnt +"&nbsp;&nbsp;" +	//잔여 일수
					"</th>"	
				);//append th
			});	//each.empVacNum
		}
	});//paging
	
	
}//휴가 신청 내역 ajax end

/*모달 리스트 END */


</script>
</head>
<body>
	<div class="main" style="min-height: 867px;">
		<div class="main-content">
			<div class="container-fluid">
			<h3 class="page-title">휴가조회(관리자)</h3>
				<div class="panel panel-headline">
<!-- 					<div class="panel-heading"> -->
<!-- 						<h3 class="panel-title">휴가항목 선택</h3> -->
<!-- 							<p class="subtitle">설명이 필요할 경우 추가 예정</p> -->
<!-- 					</div> -->
					<div class="panel-body">
						<form class="form-inline" id="vacListAdminFrm" name="vacListAdminFrm">							
							기준년도
							<!-- 달력 -->
							<div class="input-group date" id="yearDateTimePicker">
								<input type="text" class="form-control" id="baseYear" name="baseYear" />
								<span class="input-group-addon"> 
									<span class="glyphicon glyphicon-calendar"></span> <!-- 달력 아이콘 -->
								</span>
							</div> &nbsp;&nbsp;&nbsp;
<!-- 							<select class="form-control" name="searchOption" id="searchOption"> -->
<!-- 								<option value="empEmno">사번</option> -->
<!-- 								<option value="empName">이름</option> -->
<!-- 							</select> -->
							<input type="text" class="form-control" name="keyword" placeholder="검색어 입력"> 
							<input type="button" class="btn btn-primary" name="search" value="검색" onclick="searchClick()">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

							<!-- 정렬 조건 -->
							<select name="retTypeList" id="retTypeList" value="" class="form-control"><!-- 퇴직 여부 -->
								<option value="Y">재직</option>
								<option value="N">퇴직</option>
							</select> 
							<select name="deptNameList" id="deptNameList" value="부서별" class="form-control"><!-- 부서 -->
							</select> 
							<input type="hidden" id="selectTestName">
							<select name="rankNameList" id="rankNameList" value="직급별" class="form-control"><!-- 직급 -->
							</select>
							<button class="btn btn-danger" type="button" name="prog"
								style="float: right;" onclick="vacationProgressList()">
								휴가신청현황 <span class="badge" id="countNum"></span>
							</button>
						</form>
					</div>
				</div>
				<div class="panel panel-headline">
				<input type="hidden" id="empInfoHidden" name="empInfoHidden">
					<div class="panel-body"> 
						<div class="list_wrapper">
							<table class="table tablesorter table-bordered" id="vacListTable">
								<thead>
									<tr>
										<th>구분</th>
										<th>사원번호</th>
										<th>성명</th>
										<th>부서</th>
										<th>직위</th>
										<th>전체</th>
										<th>사용일수</th>
										<th>잔여일수</th>
									</tr>
								</thead>
								<tbody id="vacListTbody" name="vacListTbody">
								</tbody>
							</table>
						</div>
						
		<!-- ***************************************************************************************************************** -->
					
						<!-- Modal -->
						<div id="myModal" class="modal fade" role="dialog">
						  <div class="modal-dialog">
						
						    <!-- Modal content-->
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal">&times;</button>
						        <p class="modal-title">사원별 휴가현황</p>
						      </div>
						      <div class="modal-body">
						      <form class="form-inline" id="empVacFrm" value="">
						      	<input type="hidden" id="empEmno" name="empEmno" value="">
						        <h4 class="page-title" align="center" id="empInfoH"></h4> <!-- 클릭한 사원에 따라 바뀌게 -->
						        <div class="list_wrapper">
											<table class="table table-bordered" id="empVacListTable">
												<thead>
													<tr>
														<th>번호</th>
														<th>신청일자</th>
														<th>휴가항목</th>
														<th>휴가기간</th>
														<th>일수</th>
														<th>기타</th>
													</tr>
												</thead>
												<tbody id="empVacListTbody">
													<tr>
<!-- 														<td>1</td> -->
<!-- 														<td>2017-01-02</td> -->
<!-- 														<td>연차</td> -->
<!-- 														<td>2017-01-02~2017-01-04</td> -->
<!-- 														<td>3.0</td> -->
<!-- 														<td></td> -->
<!-- 													</tr> -->
													</tr>

												</tbody>
											</table>
										</div>
						      </form>
						      </div><!-- modal-body -->
						      <div class="modal-footer">
<!-- 						        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
						      </div>
						    </div>
						
						  </div>
						</div>
								
						<!-- paging 영역 -->
						<div align="center">
							<ul class="pagination">
								<li>
									<a title="이전페이지" href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a>
								</li>
								<li class="active"><a href="#">1<span class="sr-only">(current)</span></a></li>
								<li><a href="#">2</a></li>
								<li><a href="#">3</a></li>
							  <li><a href="#">4</a></li>
							  <li><a href="#">5</a></li>
							  <li>
									<a href="#" aria-label="Next">
										<span aria-hidden="true">&raquo;</span>
									</a>
								</li>
							</ul>
						</div>
						<!-- END list table 영역 -->
						    
						<!-- 버튼영역 -->
						<div class="text-center"> 
							<button type="button" class="btn btn-info">인쇄하기</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<button type="button" class="btn btn-success">엑셀다운</button>
						</div>
						<!-- END 버튼영역 -->
					</div>
				</div>
			</div>
		</div>
		<!-- END MAIN CONTENT -->
	</div>
	<!-- END MAIN -->
</body>
</html>