<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>근속연수별휴가설정</title>
</head>

<script>

	/*
		DB 연결할 
		continous_work_year (테이블)
		(컬럼명들)
		COWY_SERIAL_NUMBER
		COWY_CONTINOUS_TYPE
		COWY_VAC_DAYS
		COWY_DEL_YN
	*/
	
	//표 행 생성 
	$(document).on("click", "button[name=addTr]", function(){
		var addTrText =  "<tr name='vacationOption' style='display:table;width:100%;table-layout:fixed;'>"+
							"<td style='width:6%;'>"+
								'<label class="fancy-checkbox-inline">'+
									'<input type="checkbox" id="chk" ><span></span>'+
								'</label>'+
							'</td>' +
							"<td><input type='text' class='form-control' style='width:100%' ></td>" +
							"<td><input type='text' class='form-control' style='width:100%' ></td>" +
							"<td><input type='text' class='form-control' style='width:100%' ></td>" +
							'</tr>';
							
		$("#tbody tr:last").after(addTrText);
	});
	//표 행 삭제
	$(document).on("click", "button[id=deleteTr]", function(){
		var $obj = $("input[id='chk']");
		var checkCount = $obj.size();
		
		for(var i = 0 ; i < checkCount ; i++){
			if($obj.eq(i).is(":checked")){
				$obj.eq(i).parent().parent().parent().remove();
			}
		}
	});
	//체크 박스 셀렉트 ALL
	function selectAll(){
		var $obj = $("input[id='selectAll_chk']");
		var $obj2 = $("input[id='chk']");
		var $obj3 = $("input[id='notDeleteChk']");
		
		if($obj.is(":checked")){
			$obj2.prop("checked", true);
			$obj3.prop("checked", true);
		}else{
			$obj2.prop("checked", false);
			$obj3.prop("checked", false);
		}
	}
	$(function(){
		tbodyList();
	})
	
	/* 표 리스트 불러오기 start */
 	function tbodyList(){ //사원정보조회 리스트 출력
 		$('#tbody').empty(); //이전 리스트 삭제
 		
 		
		paging.ajaxFormSubmit('conWorkVacSetuplist.ajax', 'insertForm', function(rslt){ //두번째파라미터 수정할수도
 			console.log("ajaxFormSubmit -> callback");
 			console.log("결과데이터:"+JSON.stringify(rslt));

 			$('#vacationOptionTable').children('thead').css('width','calc(100% - 1em)'); //테이블 스크롤 css
 			
 			if(rslt == null){
 				$('#tbody').append( //리스트가 없을 경우 : 조회된 데이터가 없습니다
 	 				"<div class='text-center'><br><br><br><br>조회할 데이터가 없습니다.</div>"
 	 			);
 			}else if(rslt.success == "Y"){
 	 			$.each(rslt.conWorkVacSetuplist, function(k, v) {
					$('#tbody').append(
 	 					"<tr style='display:table;width:100%;table-layout:fixed;'>"+
								"<td style='width:6%;' >"+
							"<label class='fancy-checkbox-inline'>"+
								"<input type='checkbox' id='chk'>"+ //checkbox
								"<span></span>"+
							"</label>"+
						"</td>"+
						"<td >"+ v.cct +"</td>"+ 
						"<td >"+ v.cvd +"</td>"+ 
						"<td >"+ v.cn +"</td>"+ 
					"</tr>"
					);
 	 			});
 			}


			/* //테이블 정렬
			$(function(){
				$("#empModalTable").tablesorter();
			});
			
			$(function(){ 
				$("#empModalTable").tablesorter({sortList: [[0,0], [1,0]]});
			}); */
		 	
		});
 	}


	function insertForm(){
		$("#insertForm").submit();
	}

	function insertDDBB(formId) {
		var checkVount = $('input:checkbox[id="chk"]');
		var nameString = new Array('', 'conworkyear', 'vacofyear', 'note');//첫번째 ''는체크박스 입니다.

		//체크된것들만 네임 부여함.
		$('input:checkbox[id="chk"]').each(function() {
			if ($(this).prop('checked')) {
				var progTr = $(this).closest('tr');
				//var gorgTd = progTr.children().eq(1);

				for (var i = 0; i < 4; i++) { //child node 갯수가 총 4개: 체크박스,근속연수,휴가일수,비고
					//tr안에 몇번째 td인지 체크해주는것
					var progTd = progTr.children().eq(i);

					//1,2번 td에는 input type 이 text이기때문에 children() 한번해줌?
					if (i == 1 || i == 2 || i == 3) {
						var inputName = progTd.children();

						//네임 부여
						inputName.attr({
							name : nameString[i]
						});
					}//if
				}//for
			}//if checkbox
		});
	function checkedInsertName(){
		var checkCount = $("[name=chk]").length;
		
		$("[name=chk]").each(function(){
			
		})
	}
	
	function insertForm(){
		$("#insertForm").submit();
	}
	
	//디비 저장
	/*
	function insertDB(formId){
		var AnnualLeaveReflectionCheckbox = $("input[name='AnnualLeaveReflectionCheckbox']");
		var UseOrFailureCheckbox = $("input[name='UseOrFailureCheckbox']");
		var count = AnnualLeaveReflectionCheckbox.size();
		var AnnualLeaveReflectionCheckboxresult = $("input[name='AnnualLeaveReflectionCheckbox']").prop("checked");
		var UseOrFailureCheckboxresult = $("input[name='UseOrFailureCheckbox']").prop("checked");
		var AnnualLeaveReflection = $("input[name='AnnualLeaveReflection']");
		var UseOrFailure = $("input[name='UseOrFailure']");
		
		$("input[name='AnnualLeaveReflectionCheckbox']").val(AnnualLeaveReflectionCheckboxresult);
		$("input[name='UseOrFailureCheckbox']").val(UseOrFailureCheckboxresult);
		
		//checkbox에 체크되어있으면 해당하는 hidden에 true값 넣어주고 아니면 false값 넣어줌.
		for(var i = 0 ; i < count ; i++){
			if(AnnualLeaveReflectionCheckbox.eq(i).is(":checked")){
				AnnualLeaveReflection.eq(i).val('true');
			}else{
				AnnualLeaveReflection.eq(i).val('false');
			}
			
			if(UseOrFailureCheckbox.eq(i).is(":checked")){
				UseOrFailure.eq(i).val('true');
			}else{
				UseOrFailure.eq(i).val('false');
			}
		}
		
>>>>>>> c0f2d295be92994a164ab95cf7f27f8144e97538
		
		var json;
		var obj = new Object();
		var jsonObj = $("#" + formId).serializeArray();
		var jobj = {};
		var jArray = new Array();

		$(jsonObj).each(function(index, obj) {
			jobj[obj.name] = obj.value;
			//index 0에 divide : 휴가  1에 code : 00 이렇게 들어감. 그래서 json 한세트에 6개 들어가서 6개씩  짤라줌.
			//{"divide":"휴가","code":"00","title":"휴가(년차)","AnnualLeaveReflection":"false","UseOrFailure":"false","note":""} 6개 넣으면 이렇게 완성됨.
			if ((index + 1) % 3 == 0) {

				jArray.push(jobj);

				//한번하면 초기화해줘야됨. 그래야 맨밑에있는값들로만 안들어감.
				jobj = {};
			}

			console.log(index + ":" + obj.name + ":" + obj.value);
		});
		var dataObj = {"jArray":JSON.stringify(jArray)};
		paging.ajaxSubmit("/spring/conWorkVacSetDBInsert.ajax",dataObj,function(result){
			
		});
		console.log("-------------"+jArray);
		
	}
	
</script>

<body>
	<!-- MAIN -->
	<div class="main">
		<!-- MAIN CONTENT -->
		<div class="main-content">
			<div class="container-fluid">
				<h3 class="page-title">휴가항목설정</h3>
				<!-- OVERVIEW -->

				<div class="panel panel-headline">
					<div class="panel-body">
						<form class="form-inline" name="searchForm">
							<strong class="pdu_8 ftl">사업장</strong> <select
								name="attendanceDivision" class="w_120 mgl_8 mgu_8">
								<option value="vacation">인크레더블</option>
							</select> <span class="ftr">
								<button type="button" class="btn btn-primary" onClick="">검색</button>
							</span>
<<<<<<< HEAD
						</form>
					</div>
				</div>

				<!-- TABLE STRIPED -->
				<div class="panel panel-headline">
					<div class="boxArea text-center">
						<strong class="pdu_8 ftl">근속연수별휴가설정 </strong> <span class="ftr">
							<button type="button" id="addTr" class="btn btn-primary" onClick="">행추가</button>
							<button type="button" id="deleteTr" class="btn btn-primary" onClick="">행삭제</button>
						</span>
					</div>
					<div class="panel-body mgu_15">
						<form class="form-inline" name="f2" action="/spring/holidaySetDBInset.do" id="insertForm">

							<table class="table table-bordered" id="vacationOptionTable" >
								<!--  <thead> -->

								<thead id="scrollHead" style="display:table;width:100%;table-layout:fixed;">
									<tr>
										<th style="width:6%;">
											<label class="fancy-checkbox-inline">
												<input type="checkbox" id="selectAll_chk" onClick="selectAll()"> <span></span>
											</label>
										</th>
										<th >근속 연수</th>
										<th >휴가 일수</th>
										<th >비고</th>
									</tr>
								</thead>
								<tbody  id="tbody" style="display:block;height:200px;overflow:auto;">
									<!-- <tr id="headTr"></tr> -->
								</tbody>
							</table>
							<button type="button" name="saveButton" class="btn btn-primary ftr" onClick="insertDDBB('insertForm')">저장</button>
						</form>
					</div>
=======
						</div>	
						<div class="panel-body mgu_15">
							<form class="form-inline" name="f2" action="/spring/holidaySetDBInset.do" id="insertForm">
								
								<table class="table table-bordered" id="vacationOptionTable" style="980px;">
   								   <!--  <thead> -->
		                           <colgroup>
		                              <col width="3%">
		                              <col width="10%">
		                              <col width="10%">
		                              <col width="20%">
		                              <col width="10%">
		                              <col width="10%">
		                              <col width="37%">
		                           </colgroup>
		                           <thead class="scrollHead">
		                              <tr>
		                                 <th class="w3">
		                                    <label class="fancy-checkbox-inline">
		                                       <input type="checkbox" name="selectAll_chk" onClick="selectAll()">
		                                       <span></span>
		                                    </label>
		                                 </th>
		                                 <th class="text-center w10"><i class="fa fa-asterisk-red" aria-hidden="true" ></i>근속 연수</th>
		                                 <th class="text-center w10"><i class="fa fa-asterisk-red" aria-hidden="true" ></i>휴가 일수</th>
		                                 <th class="text-center w37">비고</th>
		                              </tr>
		                           </thead>
		                           <tbody class="scrollBody" id ="tbody">
		                              <tr id="headTr">
		                                 <td class="w3">
		                                    <label class="fancy-checkbox-inline">
		                                       <input type="checkbox" name="notDeleteChk">
		                                       <span></span>
		                                    </label>
		                                 </td>
		                                 <td class="w10"><input type="text" class="form-control w_80" value ="0"name="conWorkYear"></td>
		                                 <td class="w10"><input type="text" class="form-control w_80" value ="0"name="yearOfVac"></td>
		                                 <td class="w37"><input type="text" class="form-control w_300" value ="0년차 직원에게는 연차가 지급되지 않습니다."name="note"></td>
		                              </tr>
		                              <tr>
		                                 <td>
		                                    <label class="fancy-checkbox-inline">
		                                       <input type="checkbox" name="notDeleteChk">
		                                       <span></span>
		                                    </label>
		                                 </td>
		                                 <td class="w10"><input type="text" class="form-control w_80" value ="1" name="conWorkYear"></td>
		                                 <td><input type="text" class="form-control w_80"  value ="10"name="yearOfVac"></td>
		                                 <td><input type="text" class="form-control w_300" value ="1년차 법정 연차 10일"name="note"></td>
		                              </tr>
		                              <tr>
		                                 <td>
		                                    <label class="fancy-checkbox-inline">
		                                       <input type="checkbox" name="notDeleteChk">
		                                       <span></span>
		                                    </label>
		                                 </td>
		                                 <td><input type="text" class="form-control w_80" value ="2"name="conWorkYear"></td>
		                                 <td><input type="text" class="form-control w_80" value ="11"name="yearOfVac"></td>
		                                 <td><input type="text" class="form-control w_300" value ="2년차 법정 연차 11일" name="note"></td>
		                              </tr>
		                           </tbody>
		                        </table>
		                 
		                        <button type="button" name="saveButton" class="btn btn-primary ftr" onClick="insertDB('insertForm')">저장</button>
							</form>
						</div>
					</div>	
>>>>>>> c0f2d295be92994a164ab95cf7f27f8144e97538
				</div>
			</div>
		</div>
	</div>
</body>
</html>
