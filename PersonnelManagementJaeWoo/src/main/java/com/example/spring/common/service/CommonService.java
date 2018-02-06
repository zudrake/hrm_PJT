package com.example.spring.common.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.example.spring.common.dao.CommonDao;

@Service
public class CommonService {
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public List<HashMap<String,Object>> navList(){
		
		List<HashMap<String,Object>> list =commonDao.navList();
		return list;
	}//navList
	
	public HashMap<String,Object> selectMenu(HashMap<String,String> map){
		
		HashMap<String,Object> mnPrntNo = commonDao.selectMenu(map);
		return mnPrntNo;
	}//selectMenu
	
	public HashMap<String,Object> loginProcess(HashMap<String,Object> map){
		
		HashMap<String,Object> userMap = commonDao.loginProcess(map);
		return userMap;
	}//loginProcess
	
	public List<HashMap<String,Object>> authorityProcess(HashMap<String,Object> map){
		
		List<HashMap<String,Object>> userAuthList = commonDao.authorityProcess(map);
		return userAuthList;
	}//authorityProcess
}//CommonService
