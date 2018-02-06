package com.example.spring.salmanager.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.example.spring.salmanager.dao.PaycMenuDao;

@Service
public class PaycMenuService {
	Calendar cal = Calendar.getInstance();
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMdd");
	String stryearmm = formatter.format(new java.util.Date());

	@Resource(name = "paycMenuDao")
	private PaycMenuDao paycMenuDao;

	private String PRE_VIEW_PATH = "/salmanage/payc/";

	public List paycList(HashMap<String, String> map) {

		List<Object> tempList = new ArrayList();
		// List<HashMap<String, Object>> paycList = new ArrayList<HashMap<String,
		// Object>>();
		List<HashMap<String, Object>> list = paycMenuDao.paycList(map);

		String yymm = "";
		// String mm = "";
		String firstyymm = "";
		for (int i = 0; i < list.size(); i++) {

			firstyymm = list.get(0).get("SREG_YYMM").toString();
			yymm = list.get(i).get("SREG_YYMM").toString();
			// mm = yymm.substring(4,yymm.length());
			// System.out.println("sregmm : "+mm);

			tempList.add(list.get(i));

			if (Integer.parseInt(firstyymm) < Integer.parseInt(yymm)) {

				tempList.remove(i);
				tempList.add(0, list.get(i));

			}

		}
		System.out.println("tempList : " + tempList);

		return tempList;
	}

	public void makePaycInsert(HashMap<String, String> map) {
		paycMenuDao.makePaycInsert(map);
	}

	public HashMap acalPayc(HashMap<String, Object> map) {

		List<HashMap<String, Object>> deduction = new ArrayList(); // 공제 리스트.
		List<HashMap<String, Object>> itaxListtemp1 = new ArrayList();

		List<HashMap<String, Object>> itaxListtemp2 = new ArrayList();

		List<Object> itaxList = new ArrayList();
		List<Object> ltaxList = new ArrayList();

		int itax = 0; // 소득세
		int ltax = 0; // 지방세
		double npen = 0; // 국민연금 0.045
		double hfee = 0;// 건강보험 0.0312%
		double efee = 0;// 고용보험 0.0065%

		/*
		 * 실업급여 0.65% 0.65% 고용안정, 고용보험 직업능력 개발사업 150인 미만기업 0.25% 150인 이상 (우선지원 대상기업)
		 * 0.45% 150인 이상 ~ 1,000 미만 기업 0.65% 1,000인 이상 기업, 국가지방자치단체 0.85%
		 */

		/* 소득세 공제 가족수, 급여 * 월소득 300만원이상부터 20만원차이 */
		String strsal = "";// 급여
		String stritax = "";// 소득세
		String strltax = "";// 지방세
		String strnpen = "";// 국민연금
		String strhfee = "";// 건강보험
		String strefee = "";
		String emym = ""; // ex)201811 + emp_emno

		HashMap<String, Object> m1 = paycMenuDao.getEmpSal(map); // 급여, 사원번호 리스트
		// System.out.println("acalservice : "+m1);
		deduction = (List<HashMap<String, Object>>) m1.get("list");

		HashMap<String, Object> tempList = new HashMap<String, Object>();
		
		 System.out.println("deduction : "+deduction);
		// System.out.println("deduct index : "+deduction.get(0).toString().);

		// ------------------------------------ 소득세 , 주민세 계산
		// ---------------------------------------------------
		for (int i = 0; i < deduction.size(); i++) {

			emym = map.get("yymm") + deduction.get(i).get("EMP_EMNO").toString(); // ex)201811 + emp_emno
			deduction.get(i).put("emym", emym);

			strsal = deduction.get(i).get("SEMP_SAL").toString();

			int itaxsal = Integer.parseInt(strsal);
			int sal_min = (itaxsal / 10000) * 10;
			int sal_max = 0;
			int count = 0; // 소득세 sal_min , sal_max 변수
			int temp = 0;
			int tempsal = itaxsal / 1000; // while문의 itaxsal

			if (tempsal < 3000 && tempsal >= 770) {

				while (true) {

					if ((tempsal % 10 == 0) && count == 0) {
						sal_max = tempsal + 10;
						break;
					}

					if ((tempsal % 10 == 0) && count == 1) {
						sal_max = tempsal;
					}
					count = 1;
					tempsal++;

				}

				tempList.put("sal", itaxsal / 1000);
				tempList.put("sal_min", sal_min);
				tempList.put("sal_max", sal_max);
				m1 = paycMenuDao.getItax(tempList);
				itaxListtemp1 = (List<HashMap<String, Object>>) m1.get("itaxList");
				System.out.println("itaxList : " + m1);
				tempList.clear();

				// System.out.println("itaxListtemp1 : "+itaxListtemp1);
				tempList.put("emp_emno", deduction.get(i).get("EMP_EMNO").toString());

				m1 = paycMenuDao.getfamilyNum(tempList);
				itaxListtemp2 = (List<HashMap<String, Object>>) m1.get("number");

				System.out.println("number : " + itaxListtemp2);
				// System.out.println("family number :
				// "+itaxListtemp1.get(0).get("fm"+itaxListtemp2.get(0).get("fam_seq").toString()));
				stritax = (String) itaxListtemp1.get(0).get("fm" + itaxListtemp2.get(0).get("fam_seq").toString());
				itax = Integer.parseInt(stritax);

				ltax = (itax / 100) * 10;
				strltax = String.valueOf(ltax);
				// System.out.println("getfam_seq : "+itaxListtemp2.get(0).get("fam_seq"));

				// itaxListtemp1.get(0).get("fm"+itaxListtemp2.get(0).get("fam_seq"));

				deduction.get(i).put("itax", stritax);
				deduction.get(i).put("ltax", strltax);

				tempList.clear();

			}else if (tempsal < 770) {

				deduction.get(i).put("itax", "0");
				deduction.get(i).put("ltax", "0");
			}else {
				temp = tempsal % 100;
				// System.out.println("temp : "+temp);

				if (temp % 20 == 0) { // 40 60 80 100

					sal_max = sal_min + 20;

				} else {

					sal_min -= 10;
					sal_max = sal_min + 20;

				}
				tempList.put("sal", itaxsal / 1000);
				tempList.put("sal_min", sal_min);
				tempList.put("sal_max", sal_max);
				// paycMenuDao.getItax(tempList);

				m1 = paycMenuDao.getItax(tempList);
				itaxListtemp1 = (List<HashMap<String, Object>>) m1.get("itaxList");
				tempList.clear();

				tempList.put("emp_emno", deduction.get(i).get("EMP_EMNO").toString());
				m1 = paycMenuDao.getfamilyNum(tempList);
				itaxListtemp2 = (List<HashMap<String, Object>>) m1.get("number");

				stritax = (String) itaxListtemp1.get(0).get("fm" + itaxListtemp2.get(0).get("fam_seq"));
				itax = Integer.parseInt(stritax);

				ltax = (itax / 100) * 10;
				strltax = String.valueOf(ltax);

				tempList.clear();

				deduction.get(i).put("itax", stritax);
				deduction.get(i).put("ltax", strltax);

			}
			// ------------------------------------ 소득세 , 주민세 계산
			// ---------------------------------------------------

			// ------------------------------------ 국민연금, 건강보험
			// --------------------------------------------------
			// ------------------------------------ 고용보험
			// ----------------------------------------------------
			if (deduction.size() >= 1000) {

			} else if (deduction.size() < 1000 && deduction.size() >= 150) {

			} else {

			}

			efee = Double.parseDouble(strsal) * 0.0065;
			strefee = String.format("%.0f", efee);
			deduction.get(i).put("efee", strefee);

			if (Double.parseDouble(strsal) >= 290000) {

				npen = Double.parseDouble(strsal) * 0.045;
				hfee = Double.parseDouble(strsal) * 0.0312;

				strnpen = String.format("%.0f", npen);
				strhfee = String.format("%.0f", hfee);

				deduction.get(i).put("npen", strnpen);
				deduction.get(i).put("hfee", strhfee);

			} else {

				strnpen = String.format("%.0f", npen);
				strhfee = String.format("%.0f", hfee);

				deduction.get(i).put("npen", strnpen);
				deduction.get(i).put("hfee", strhfee);

			}

		}
		// ------------------------------------ 고용보험
		// ----------------------------------------------------
		// ------------------------------------ 국민연금, 건강보험
		// --------------------------------------------------

		// map.put("deduction", deduction);
		// map.put("itaxList", itaxList);
		// map.put("ltaxList", ltaxList);
		System.out.println("service map : " + map);

		paycMenuDao.acalPayc(map);
		return map;
	}

	public List selectPayc(HashMap<String, String> map) {
		List<HashMap<String, Object>> list = paycMenuDao.selectPayc(map);
		return list;
	}

	public int getYear() {
		int year = Integer.parseInt(stryearmm.substring(0, 4));

		return year;
	}

	public int getMonth() {
		int month = Integer.parseInt(stryearmm.substring(5, 6));
		return month;
	}

	public int getLastDay() {

		int lastday = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		return lastday;
	}

	public int getToday() {
		int day = Integer.parseInt(stryearmm.substring(6, 8));
		return day;
	}

}
