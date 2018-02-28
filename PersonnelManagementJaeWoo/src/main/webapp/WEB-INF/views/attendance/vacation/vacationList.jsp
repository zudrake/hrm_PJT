<!--
	휴가조회(사원) - 유성실,신지연
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>휴가조회(사원)</title>
<style>
.table > tbody > tr > td { 
	vertical-align: middle;
}
</style>
<script>

	$(function() {
		
		//휴가일수설정에 등록된 사원인지 체크하여 alert창 띄우기
		paging.ajaxFormSubmit("empVacChk.ajax", "vacListFrm", function(rslt){
			
			$('#vacStatementTbody').append( //리스트가 없을 경우 : 조회된 데이터가 없습니다
	 				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"
	 			);
			$('#printBtn').attr("disabled", true); //인쇄버튼 막기
			$('#excelBtn').attr("disabled", true); //엑셀버튼 막기
			
			if(rslt != '1'){
				alert('휴가일수가 설정되지 않았습니다.\n관리자에게 문의하세요.');
			}else{
				$('.button').attr('disabled',false);
				vacationListEmpRemindingVac(); //사원별 휴가 개수
				vacationListSelect(); //휴가신청내역 ajax
			}
		});
// 		$('.table tr').children().addClass('text-center'); //테이블 내용 가운데 정렬
// 		escKey();
	});
	
	//테이블 정렬
	function tablesorterFunc(){
		$("#vacStatementTable").tablesorter();
		$("#vacStatementTable").tablesorter({sortList: [[0,0], [1,0]]});
	}
	
	function vacationListEmpRemindingVac(){
		paging.ajaxFormSubmit("vacationListEmpRemindingVac.ajax", "vacListFrm", function(rslt){
			console.log("결과데이터:"+JSON.stringify(rslt));

	 			$.each(rslt.empRemindingVacList, function(k, v) {
	 				$('#empEmno').text($("input[type=hidden][name=empEmno]").val());
	 				$('#empName').text(v.empName);
	 				$('#baseDate').text(v.baseDate);
	 				$('#emreVacUd').text(v.emreVacUd);
	 				$('#emrePvacUd').text(v.emrePvacUd);
	 				$('#remndrDate').text(v.remndrDate);
	 			});
		});
	}
	
	//사원별 휴가 개수, 휴가신청내역 ajax
	function vacationListSelect(){
		paging.ajaxFormSubmit("vacationListSelect.ajax", "vacListFrm", function(rslt){
// 			console.log("결과데이터:"+JSON.stringify(rslt));

			$('#vacStatementTable').children('thead').css('width','calc(100% - 1.1em)'); //테이블 스크롤 css

			if(rslt == null || rslt.success == "N"){
				$('#vacStatementTbody').append( //리스트가 없을 경우 : 조회된 데이터가 없습니다
	 				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"
	 			);
			}else if(rslt.success == "Y"){
	 			var i = 1;
	 			$.each(rslt.vacationProgressList, function(k, v) {
					$('#vacStatementTbody').append(
							"<tr data-toggle='modal' data-target='#myModal' id='"+v.vastSerialNumber+"' onclick='empVacationList("+JSON.stringify(v.vastSerialNumber)+")' style='display:table;width:100%;table-layout:fixed;cursor:pointer;'>"+
		 					"<td>"+ i +"</td>"+ //번호
		 					"<td>"+ v.vastCrtDate +"</td>"+ //신청일
		 					"<td>"+ v.vastType +"</td>"+ //휴가항목
		 					"<td>"+ v.vastTerm +"</td>"+ //휴가기간
		 					"<td>"+ v.vastVacUd +"</td>"+ //일수
		 					"<td>"+ v.vastProgressSituation +"</td>"+ //결재상황
// 		 					"<td>"+ v.vastCont +"</td>"+ //휴가사유
						"</tr>"
					);
					i++; //번호 1 증가
					if(v.vastProgressSituation == "승인대기"){ //승인대기면 색상 변경
						$("#vacStatementTbody tr:last").attr("bgcolor","#f0ad4e");
					}
	 			});
			}
			$('#empInfo tr').children().addClass('text-center'); //테이블 내용 가운데 정렬
			$('#vacStatementTable tr').children().addClass('text-center'); //테이블 내용 가운데 정렬
			tablesorterFunc();
		});
	}

	
	/*모달 리스트 START */
	function empVacationList(vastSerialNumber){
		
		$('input[name=vastSerialNumber]').val(vastSerialNumber);
		
		paging.ajaxFormSubmit("empVacListDetail.ajax", "vacListFrm", function(rslt){
// 			console.log("ajaxFormSubmit -> callback");
// 			console.log("결과데이터:"+JSON.stringify(rslt));
			
			//리스트가 없을 경우
	 		if(rslt == null || rslt.success == "N"){
//	 			$('#empVacListTbody').append(
//	 				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"		
// 	 			)
//	 		//리스트가 있을 경우	
	 		} else if(rslt.success == "Y"){
	 			$.each(rslt.empVacListDetail, function(k, v) {
	 				$('#vastCrtDate').val(v.vastCrtDate); //휴가신청일
	 				$('#vastC').val(v.vastC).attr("selected","selected") //휴가구분
	 				$('#vastProgressSituation').val(v.vastProgressSituation); //진행상태
	 				$('#vastStartDate').val(v.vastStartDate); //휴가시작일
	 				$('#vastEndDate').val(v.vastEndDate); //휴가종료일
	 				$('#vastVacUd').val(v.vastVacUd); //일수
	 				$('#vastCont').val(v.vastCont); //휴가사유
	 				
	 				if(v.vastProgressSituation == '승인완료' || v.vastProgressSituation == '승인취소'){
	 					$('#vastCrtDate').attr("readonly",true); //휴가신청일
		 				$('#vastC').attr("readonly",true); //휴가구분
		 				$('#vastStartDate').attr("readonly",true); //휴가시작일
		 				$('#vastEndDate').attr("readonly",true); //휴가종료일
		 				$('#vastCont').attr("readonly",true); //휴가사유
		 				
	 					$('#footer').children().hide(); //승인완료면 수정,삭제 불가능하게 버튼 제거
	 				}else{
	 					$('#vastCrtDate').attr("readonly",false); //휴가신청일
		 				$('#vastC').attr("readonly",false); //휴가구분
		 				$('#vastStartDate').attr("readonly",false); //휴가시작일
		 				$('#vastEndDate').attr("readonly",false); //휴가종료일
		 				$('#vastCont').attr("readonly",false); //휴가사유
		 				
	 					$('#footer').children().show();
	 				}
	 			});
	 		}
		});
	}
	/*모달 리스트 END */
	
	//휴가 삭제
	function modalDelete(){
		
		var result = confirm('삭제하시겠습니까?');
		
		if(result){ //삭제
			paging.ajaxFormSubmit("vacationListDelete.ajax", "vacListFrm", function(rslt){
//	 			console.log("ajaxFormSubmit -> callback");
//	 			console.log("결과데이터:"+JSON.stringify(rslt));

				//리스트가 없을 경우
		 		if(rslt == null || rslt.success == "N"){
//		 			$('#empVacListTbody').append(
//		 				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"		
//	 	 			)
		 		//리스트가 있을 경우	
		 		} else if(rslt.success == "Y"){
					alert('삭제되었습니다.');
					window.location.reload();
		 		}
			});
		}
	}
	
	//인쇄
	function vacListPrint(){
		$('#mainDiv').printElement();
	}
	
	//엑셀 다운
	function vacListExcelExport(){
		$("#vacStatementTable").excelexportjs({
			containerid: 'vacStatementTable',
			datatype: 'table'
		});
	}

	//모달 esc 눌러서 끄게
// 	function escKey(){
// 		$('#vastCont').keydown(function(e) {
// 			if (e.keyCode == 27) {
// 				$('#myModal').modal('hide'); //키보드 esc 눌러도 꺼지게, selectbox 불러오기, 수정, 삭제
// 			}
// 		});
// 	}
	
/* 	
	//테이블 마우스오버시 (행을 지날 때), 색 바뀜
	$(document).ready(function(){
		$('#vacList tbody tr').mouseover(function(){ 
			$(this).css("backgroundColor","#f2f2f2"); 
		}); 
		$('#vacList tbody tr').mouseout(function(){ 
			$(this).css("backgroundColor","#fff"); 
		});
	});
*/
</script>
</head>
<body>
	<div class="main" style="min-height: 867px;" id="mainDiv">
		<div class="main-content">
			<div class="container-fluid">
			<h3 class="page-title">휴가조회(사원)</h3>
				<div class="panel">
					<div class="panel-body">
						<form id="vacListFrm">
							<input type="hidden" name="empEmno" value="<%=(String)session.getAttribute("userEmno")%>"> <!-- 사원번호 -->
							<input type="hidden" name="vastSerialNumber"> <!-- 휴가내역일련번호 -->
						</form>
						<table class="table table-bordered" id="empInfo">	
							<tr>
								<th>사원번호</th>
								<td id="empEmno"></td>
								<th>성명</th>
								<td id="empName"></td>
								<th>연차기간</th>
								<td id="baseDate"></td> <!-- YYYY.MM.DD ~ YYYY.MM.DD -->
							</tr>
							<tr>
								<th>전체일수</th>
								<td id="emreVacUd"></td>
								<th>사용일수</th>
								<td id="emrePvacUd"></td>
								<th>잔여일수</th>
								<td id="remndrDate"></td>
							</tr>
						</table>
					</div>
				</div>
				
				<div class="panel panel-headline"> 
					<div class="panel-body">
						<div class="list_wrapper"><!-- list table 영역 -->
							<table class="table tablesorter" id="vacStatementTable">
								<thead style="display:table;width:100%;table-layout:fixed;">
									<tr>
										<th>번호</th>
										<th>신청일</th>
										<th>휴가항목</th>
										<th>휴가기간</th>
										<th>일수</th>
										<th>진행상태</th>
									</tr>
								</thead>
								<tbody id="vacStatementTbody" style="display:block;height:350px;overflow:auto;">
								<!-- ajax 내용 불러오기 -->
								</tbody>
							</table>
						</div><!-- END list table 영역 -->
						
		
						<div id="myModal" class="modal fade" role="dialog"><!-- Modal -->
						  <div class="modal-dialog modal-lg">
						    <div class="modal-content"><!-- Modal content-->
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal">&times;</button>
						        <p class="modal-title">휴가조회</p>
						      </div>
						      <div class="modal-body">
										<form class="form-inline" id="vacReqFrm" name="vacReqFrm" method="post">
											<input type="hidden" name=""><!-- 권한 -->
				<!-- 							<input type="hidden" name="empEmno" value="575657036">사원번호 -->
											
											<table class="table table-bordered">
												<tr>
													<td>휴가신청일</td>
													<td>
														<!-- 사원 권한: 오늘 날짜 고정 -->
				<!-- 									  <input type="text" class="form-control" name="vastCrtDate" id="tDate" readonly> -->
														
														<!-- 관리자 권한: 달력 -->
														<div class="input-group date" id="crtDate">
													  	<input type="text" class="form-control" id="vastCrtDate" name="vastCrtDate"/>
													    <span class="input-group-addon">
														    <span class="glyphicon glyphicon-calendar"></span> <!-- 달력 아이콘 -->
													    </span>
													  </div>
				
													</td>
													<td>휴가구분</td>
													<td>
														<select name="vastC" class="form-control" id="vastC">
															<option id="V1" value="V1">연차</option>										
															<option id="V2" value="V2">반차</option>
															<option id="V3" value="V3">생리휴가</option>
															<option id="V4" value="V4">경조휴가</option>
															<option id="V5" value="V5">출산휴가</option>
															<option id="V6" value="V6">병가</option>
														</select>
													</td>
													<td>진행상태</td>
													<td><input type="text" class="form-control" name="vastProgressSituation" id="vastProgressSituation" value="승인대기" readonly></td>
												</tr>
												<tr>
													<td>휴가기간</td>
													<td colspan="5">
													<div>
														<div class="input-group date" id="startDate"><!-- 달력-->
													  		<input type="text" class="form-control" id="vastStartDate" name="vastStartDate"/>
														    <span class="input-group-addon">
															    <span class="glyphicon glyphicon-calendar"></span> <!-- 달력 아이콘 -->
														    </span>
														</div>
														~
														<div class="input-group date" id="endDate">
													  		<input type="text" class="form-control" id="vastEndDate" name="vastEndDate"/>
														    <span class="input-group-addon">
															    <span class="glyphicon glyphicon-calendar"></span> <!-- 달력 아이콘 -->
														    </span>
													  </div>
														(일수: <input type="text" class="form-control" id="vastVacUd" name="vastVacUd" readonly>)
													</div>
													</td>
												</tr>
												<tr>
													<td>휴가사유</td>
													<td colspan="5"><div><input type="text" class="form-control" name="vastCont" id="vastCont" size="100"></div></td>
												</tr>
											</table>
										</form>
						      </div><!-- modal-body -->
						      <div class="modal-footer" style="text-align:center;" id="footer">
										<button type="button" class="btn btn-primary">수정</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button type="button" class="btn btn-primary" onClick="modalDelete()">삭제</button>
						      </div>
						    </div>
						  </div>
						</div>
						<div class="text-center"><!-- 버튼영역 -->
							<button type="button" class="btn btn-primary" id="printBtn" onClick="vacListPrint()">인쇄하기</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<button type="button" class="btn btn-primary" id="excelBtn" onClick="vacListExcelExport()">엑셀다운</button>
						</div><!-- END 버튼영역 -->
					</div>
				</div>
			</div><!-- END MAIN CONTENT -->
		</div>
	</div><!-- END MAIN -->

</body>
</html>