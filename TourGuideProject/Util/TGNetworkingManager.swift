/*

파일명: TGNetworkingManager.swift
작성자: 2020/07/08 유현지

설명:
AlamofireObjectMapper 라이브러리를 통한 API 통신 + Json 파일을 받아 TGDataManager에 있는 데이터 형식으로 변환하는 작업을 하는 클래스.
*/
 
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

var contentTypeId = 12
let numOfRows = 10
let serviceKey = "a74NIAcB4Qf%2BtsFyvKMQuUgHtj1GC8P%2Fog5YLsqQJs2kvhfTVrhZGc4NhIYdQJ1dl6U0Sq8DF7srBwrfoZloDA%3D%3D"
let TourAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?serviceKey="
            + serviceKey
            + "&pageNo=1&numOfRows="
            + String(numOfRows)
            + "&MobileApp=AppTest&MobileOS=IOS&arrange=Q&cat1=&sigunguCode=&cat2=&cat3=&listYN=Y&modifiedtime=&_type=json&contentTypeId=12&areaCode="




let FestivalAPI = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchFestival?serviceKey="
                + serviceKey
                + "&MobileOS=IOS&MobileApp=AppTest&arrange=P&listYN=Y&_type=json&"
                + String(10)
                + "&eventStartDate=20200101"



class TGNetworkingManager {
    
    // API 통신 후 받아온 json 파일을 변환해 최종적으로 쓰일 DataSet에 할당하는 함수
    func loadTourSpotData(_ areaCode:Int, update: @escaping (_ a: [TourData]) -> Void) {
        
        var validTourInfo = [TourData]()
        
        Alamofire.request(TourAPI + String(areaCode)).responseObject { (response: DataResponse<TourInfo>) in
            if let afResult = response.result.value?.response {
                if let afHead = afResult.head {
                    // API 통신 결과가 OK인 경우에만 시도
                    switch afHead.resultMsg {
                    case "OK":
                        if let afItems = afResult.body?.items?.item {
                            for afItem in afItems {
                                
                                let newTourInfo = TourData(title: afItem.title, areaCode: afItem.areaCode, addr1: afItem.addr1, addr2: afItem.addr2, image: afItem.image, tel: afItem.tel, contenttypeid: afItem.contenttypeid)
                                
                                validTourInfo.append(newTourInfo)
                            }
                            
                            update(validTourInfo)
                        }
                    default:
                        print("Data load failed")
                    }
                }
            } else {
                print("API load failed")
            }
        }
    }
    
    // API 통신 후 받아온 json 파일을 변환해 최종적으로 쓰일 DataSet에 할당하는 함수
    func loadFestivalData(update: @escaping (_ a: [FestivalData]) -> Void) {
        
        var validFestivalInfo = [FestivalData]()
        
        Alamofire.request(FestivalAPI).responseObject { (response: DataResponse<FestivalInfo>) in
            if let afResult = response.result.value?.response {
                if let afHead = afResult.head {
                    // API 통신 결과가 OK인 경우에만 시도
                    switch afHead.resultMsg {
                    case "OK":
                        if let afItems = afResult.body?.items?.item {
                            for afItem in afItems {
                            
                                let newFestivalInfo = FestivalData(title: afItem.title, addr1: afItem.addr1, addr2: afItem.addr2, eventstartdate: afItem.eventstartdate, eventenddate: afItem.eventenddate, image: afItem.image, thumbnail: afItem.thumbnail, tel: afItem.tel)
                                
                                
                                
                                validFestivalInfo.append(newFestivalInfo)
                            }
                            
                            update(validFestivalInfo)
                        }
                    default:
                        print("Data load failed")
                    }
                }
            } else {
                print("API load failed")
            }
        }
    }
}

extension Int {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let tempDate = dateFormatter.date(from: String(self))
        
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if tempDate != nil {
            return dateFormatter.string(from: tempDate!)
        }else {
            return ""
        }
    }
}


