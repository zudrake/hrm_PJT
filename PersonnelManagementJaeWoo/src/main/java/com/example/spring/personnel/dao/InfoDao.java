package com.example.spring.personnel.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
//import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("infoDao")
public class InfoDao {

	@Autowired
	private SqlSession sqlSeesson;
	private String nameSpaceName="Info.";
	
	
	public void infoInsert(HashMap<String,String> map){
		
		System.out.println("dao 맵 확인 :" +map);
		
		this.sqlSeesson.insert(nameSpaceName+"infoInsert",map);
	}
	
	public List<HashMap<String,Object>> infoSearch(HashMap<String,Object> map) {
		
	
		System.out.println("다오진입 + map값" + map.get("empName"));
		
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		
		
		list=this.sqlSeesson.selectList(nameSpaceName + "infoSearch",map);
		
		
		return list;
		

	}
}	
