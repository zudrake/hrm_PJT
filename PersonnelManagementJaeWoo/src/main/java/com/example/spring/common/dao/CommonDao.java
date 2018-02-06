package com.example.spring.common.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonDao")
public class CommonDao {
	@Autowired
	private SqlSession sql;
	private String namespace="common.";
	
	public List<HashMap<String,Object>> navList(){
		
		List<HashMap<String,Object>> list = this.sql.selectList(namespace+"navList");
		return list;
	}//navList
	
	public HashMap<String,Object> selectMenu(HashMap<String,String> map){
		
		HashMap<String,Object> mnPrntNo = this.sql.selectOne(namespace+"selectMenu",map);
		return mnPrntNo;
	}//selectMenu
	
	public HashMap<String,Object> loginProcess(HashMap<String,Object> map){
		
		HashMap<String,Object> userMap = this.sql.selectOne(namespace+"loginProcess",map);
		return userMap;
	}//loginProcess
	
	public List<HashMap<String,Object>> authorityProcess(HashMap<String,Object> map){
		
		List<HashMap<String,Object>> userAuthList = this.sql.selectList(namespace+"authorityProcess", map);
		return userAuthList;
	}
}//CommonDao
