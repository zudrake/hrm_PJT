<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	var emno = "0905000211";
	var deptCode = 2;
	var crtfCode = 3;
	
	//페이지 로딩시 증명서 전체데이터 가져온다
	paging.ajaxSubmit("certificateWhole.do","",function(rslt){
		 console.log("결과데이터 : " + JSON.stringify(rslt));
		 var tbody = $("#tbodyId");
		 
		 $.each(rslt,function(index){
			 tbody.append("<tr name='trName' data-toggle='modal' data-target='#viewModal' onclick='certificateInfo($(this))'>"+
			 					"<td name='crtfSeq'>"+rslt[index].crtfSeq+"</td>" +		//발행번호
			 					"<td name='empEmno'>"+rslt[index].empEmno+"</td>" +		//사원번호
			 					"<td name='empName'>"+rslt[index].empName+"</td>" +		//성명
			 					"<td name='commName'>"+rslt[index].commName+"</td>" +	//증명서종류
			 					"<td name='crtfUse'>"+rslt[index].crtfUse+"</td>" +		//용도
			 					"<td name='crtfDate'>"+rslt[index].crtfDate+"</td>" +	//신청일
			 			  "</tr>");
		 });
	});
	
	//검색 날짜선택시
	$("[name='startDate'],[name='endDate']").datetimepicker({ 
		viewMode : 'days',
		format : 'YYYY-MM-DD'
	});
	
	//검색버튼 클릭시
	var search = function(){
		
		var tbody = $("#tbodyId");
		var trName = $("tr[name='trName']");
		
		trName.remove();
		
		var formId = $("#formId").attr("id");
		
		paging.ajaxFormSubmit("certificateSearch.do",formId,function(rslt){
			console.log("결과데이터 : " + JSON.stringify(rslt));
			
			$.each(rslt,function(index){
				tbody.append("<tr name='trName' data-toggle='modal' data-target='#viewModal' onclick='certificateInfo($(this))'>"+
	 					"<td name='crtfSeq'>"+rslt[index].crtfSeq+"</td>" +		//발행번호
	 					"<td name='empEmno'>"+rslt[index].empEmno+"</td>" +		//사원번호
	 					"<td name='empName'>"+rslt[index].empName+"</td>" +		//성명
	 					"<td name='commName'>"+rslt[index].commName+"</td>" +	//증명서종류
	 					"<td name='crtfUse'>"+rslt[index].crtfUse+"</td>" +		//용도
	 					"<td name='crtfDate'>"+rslt[index].crtfDate+"</td>" +	//신청일
	 			  "</tr>");
			});
		});
	}
	
	//증명서 상세정보
	var certificateInfo = function(data){
		
		//각 tr의 정보를 가져온다
		var crtSeq = data.find("td[name='crtfSeq']").text();		//발행번호
		var empEmno = data.find("td[name='empEmno']").text();		//사원번호
		var empName = data.find("td[name='empName']").text();		//성명
		var commName = data.find("td[name='commName']").text();		//증명서종류
		var crtfUse = data.find("td[name='crtfUse']").text();		//용도
		var crtfDate = data.find("td[name='crtfDate']").text();		//신청일
		
		var formId = $("#viewForm");
		//viewForm에 데이터를 넣는다
		formId.find("[name='crtfSeq']").val(crtSeq);
		formId.find("[name='empEmno']").val(empEmno);
		formId.find("[name='empName']").val(empName);
		formId.find("[name='select']").val(commName).prop("selected",true);
		formId.find("[name='use']").val(crtfUse);
		formId.find("[name='application']").val(crtfDate);
		
		//사원정보가져오기
		var obj = {};
		obj.emno = emno;
		
		paging.ajaxSubmit("empInfo.do",obj,function(rslt){
			 $("#viewModal #viewForm input[name='deptName']").val(rslt.deptName); //부서명
			 $("#viewModal #viewForm input[name='rankName']").val(rslt.rankName); //직위/직급명
		});
	}
	
	//증명서신청 
	var insertData = function(){
		
		//신청시 오늘날짜 세팅
		var d = new Date();
		var year = d.getFullYear();
		var month = d.getMonth()+1;
		var day = d.getDate();
		
		//월, 일이 1자리수이면 0을붙인다
		if(("" + month).length == 1) {month = "0" + month;} 
		if(("" + day).length   == 1) {day = "0" + day;}

		$("[name='application']").val(year+'-'+month+'-'+day);
		
		//신청시 사원정보 가져오기
		var obj = {};
		obj.emno = emno;
		
		paging.ajaxSubmit("empInfo.do",obj,function(rslt){
			 $("#insertModal #insertForm input[name='empEmno']").val(rslt.empEmno);
			 $("#insertModal #insertForm input[name='deptName']").val(rslt.deptName);
			 $("#insertModal #insertForm input[name='empName']").val(rslt.empName);
			 $("#insertModal #insertForm input[name='rankName']").val(rslt.rankName);
		});
		
		//신청버튼클릭시
		$("#insertBtn").click(function(){
			$("#insertForm [name='crtfCode']").val(crtfCode);
			
			var formId = $("#insertForm").attr("id");
			
			var url = "/spring/certificateInsert.do"; 
			
			if($("#insertForm select[name='select']").val() == "증명서종류"){ //증명서 선택 안했을시
				alert("증명서를 선택하십시오");
				return false;
			}else {	//증명서 선택했을시
				if(confirm("저장하시겠습니까?") == true){
					paging.ajaxFormSubmit(url,formId, function(result){
						console.log("result : " + result);
						if(result > 0){
							alert("저장되었습니다");
							location.href="/spring/certificateIssue.do";
						}else{
							alert("저장실패. 다시 입력해주세요");
						}
					});
				}else{
					return false;
				}
			}
		});
		
	}
	
	
</script>