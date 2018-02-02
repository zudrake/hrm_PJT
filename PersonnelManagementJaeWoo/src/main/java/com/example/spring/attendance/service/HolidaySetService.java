package com.example.spring.attendance.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.example.spring.attendance.dao.HolidaySetDao;
import com.example.spring.attendance.entity.JsonData;
import com.example.spring.attendance.entity.JsonDataVac;


@Service
public class HolidaySetService {

	private static final Logger logger = LoggerFactory.getLogger(HolidaySetService.class);

	@Resource(name="holidaySetDao")
	private HolidaySetDao holidaySetDao;

	public int holidaySetDBInsert(ArrayList<JsonData> jsonArrayList) {
		int result = holidaySetDao.holidaySetDBInsert(jsonArrayList);

		return result;
	}

	//년차수에 따른 연차 디비 Insert
	public int conWorkVacSetDBInsert(ArrayList<JsonDataVac>jsonArrayList) {
		int result = holidaySetDao.conWorkVacSetDBInsert(jsonArrayList);
		return result;
	}

	//년차수에 따른 연차 List 불러오기
	public List<HashMap<String,Object>> conWorkVacSetupList(HashMap<String,Object> map) {

		List<HashMap<String,Object>> list = holidaySetDao.conWorkVacSetupList(map);

		logger.debug("service>>> " + list);

		return list;
	}
}
