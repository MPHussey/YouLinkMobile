//
//  CenterMenuViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-12.
//\

import Foundation
import SwiftUI

class CenterMenuViewModel:ObservableObject{
    @Published var menuData: MenuData = [:]
    
    @Published var expandedSections: Set<String> = []
    
    init(){
        loadFromEmbeddedJSON()
    }
    
    private func loadFromEmbeddedJSON(){
        let jsonString="""
        {
        "applications": [
        {
            "label": "AeroOps",
            "url": "https://intraneti.srilankan.com/aopsadmin"
        },
        {
            "label": "AeroTrack",
            "url": "https://intraneti.srilankan.com/aerotrack"
        },
        {
            "label": "ARD - Internet",
            "url": "https://tc36.resdesktop.altea.amadeus.com/app_ard/apf/init/login?SITE=AULPAULP&LANGUAGE=GB&MARKETS=ARDW_ESSENTIAL,ARDW_PROD_WBP"
        },
        {
            "label": "ARD - Intranet",
            "url": "https://tc36.intranet.resdesktop.altea.amadeus.com/app_ard/apf/init/login?SITE=AULPAULP&LANGUAGE=GB&MARKETS=ARDW_ESSENTIAL,ARDW_PROD_WBP"
        },
        {
            "label": "My HR Space",
            "url": "https://hradmin.srilankan.com/"
        },
        {
            "label": "Araksha",
            "url": "https://araksha.srilankan.com:9043/araksha/secure/main"
        },
        {
            "label": "AORS-(GHDR)",
            "url": "https://intraneti.srilankan.com/AORS"
        },
        {
            "label": "BCCS",
            "url": "https://intraneti.srilankan.com/bccs"
        },
        {
            "label": "Baggage Management System (BMS)",
            "url": "https://slal.luggagelogistics.net/Supervisor"
        },
        {
            "label": "Baggage Processing System (BPS)",
            "url": "http://intraneti.srilankan.com/BPS"
        },
        {
            "label": "CargoMax",
            "url": "https://intraneti.srilankan.com/scas"
        },
        {
            "label": "Crew Space Portal",
            "url": "https://crewspace.srilankan.com/"
        },
        {
            "label": "DPub",
            "url": "http://dpub.srilankan.com/"
        },
        {
            "label": "Duty Travel",
            "url": "http://intraneti.srilankan.com/dutytravel"
        },
        {
            "label": "EasyPass",
            "url": "http://intraneti.srilankan.com/Easypass_V1"
        },
        {
            "label": "eLearning System",
            "url": "https://ilearn.srilankan.com"
        },
        {
            "label": "Exchange Rates",
            "url": "https://intraneti.srilankan.com/Exchange_rates"
        },
        {
            "label": "FDCA",
            "url": "https://intraneti.srilankan.com/FDCA"
        },
        {
            "label": "Finesse Suite",
            "url": "https://finesse-ul.accelyakale.net/ul-prod"
        },
        {
            "label": "ForeRunner",
            "url": "http://intraneti.srilankan.com/frr/"
        },
        {
            "label": "GAL Update",
            "url": "https://intraneti.srilankan.com/Pages/GAL-update.aspx"
        },
        {
            "label": "Government Travel",
            "url": "http://intraneti.srilankan.com/GovTrav/"
        },
        {
            "label": "iBUDGET",
            "url": "https://intraneti.srilankan.com/IBUDGET"
        },
        {
            "label": "IPV",
            "url": "https://intraneti.srilankan.com/ipv/"
        },
        {
            "label": "i-FLEET",
            "url": "http://intraneti.srilankan.com/ifv",
            "keywords": [
                "ifleet"
            ]
        },
        {
            "label": "iCargo",
            "url": "https://ulcargo.ibsplc.aero/icargo/login.do"
        },
        {
            "label": "MediCash",
            "url": "https://intraneti.srilankan.com/medicash/login.asp"
        },
        {
            "label": "oneworld Training (Refresher)",
            "url": "https://srilankanairlines.sharepoint.com/sites/oneworldopass/_layouts/15/appredirect.aspx?instance_id={1635D337-5138-4612-9480-B109A5044SC9}#$PVisited=0"
        },
        {
            "label": "oneworld Training (Initial)",
            "url": "https://bi.oneworld.com/opass/training/srilankanairlinestraining"
        },
        {
            "label": "Oracle EBS",
            "url": "http://ulcakofapp1v.srilankan.corp:8006/OA_HTML/AppsLocalLogin.jsp"
        },
        {
            "label": "PriceWise",
            "url": "https://pricewise.srilankan.com:8088/slp-web/"
        },
        {
            "label": "Properties Work Request",
            "url": "https://intraneti.srilankan.com/IWR"
        },
        {
            "label": "RevenuePlus Passenger",
            "url": "https://revenueplus.srilankan.com:8443/erevenueplus/index.jsp"
        },
        {
            "label": "RevenuePlus Cargo",
            "url": "https://revenueplus.srilankan.com:9443/crevenueplus/index.jsp"
        },
        {
            "label": "RSR",
            "url": "http://intraneti.srilankan.com/RSR"
        },
        {
            "label": "SARA",
            "url": "https://saraapp.srilankan.com/ux/myitapp/#/catalog/home"
        },
        {
            "label": "Staff Travel",
            "url": "https://stafftravel.srilankan.com/",
            "keywords": [
                "Charika",
                "CharikaPlus",
                "Ex Staff",
                "zed",
                "myidtravel",
                "my id"
            ]
        },
        {
            "label": "SkyBoard",
            "url": "http://intraneti.srilankan.com/skyboard/"
        },
        {
            "label": "UL-Tra",
            "url": "http://intraneti.srilankan.com/TRNR/"
        },
        {
            "label": "Veritas",
            "url": "http://intraneti.srilankan.com/veritas"
        },
        {
            "label": "QCKS",
            "url": "http://intraneti.srilankan.com/QCKS/"
        },
        {
            "label": "CRIS",
            "url": "https://crisul.mercator.com/CRM"
        },
        {
            "label": "Learning Management System",
            "url": "https://lms.srilankanaviationcollege.com"
        }
        ],
        "corporate": [
        {
            "label": "Vision and Mission",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/Corporate-Vision.aspx"
        },
        {
            "label": "Corporate OChart",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/ochart.aspx"
        },
        {
            "label": "Corporate Contacts",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/Corporate-Contacts.aspx"
        },
        {
            "label": "Destinations",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/Destinations.aspx"
        },
        {
            "label": "Company Song",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/Company-Song.aspx"
        },
        {
            "label": "Corporate Holidays",
            "url": "https://youlink.srilankan.com/Corporate-Information/Pages/Corporate-Holidays.aspx"
        }
        ],
        "divisions": [
        {
            "label": "Aviation College",
            "url": "https://youlink.srilankan.com/sites/iaa"
        },
        {
            "label": "Cargo",
            "url": "https://youlink.srilankan.com/sites/cargo/"
        },
        {
            "label": "Commercial Operations",
            "url": "https://youlink.srilankan.com/sites/commercialops/"
        },
        {
            "label": "Corporate Communications",
            "url": "https://youlink.srilankan.com/sites/media"
        },
        {
            "label": "Corporate Quality",
            "url": "https://srilankanairlines.sharepoint.com/sites/OperationalQuality"
        },
        {
            "label": "Corporate Safety",
            "url": "https://youlink.srilankan.com/SafetyInformationCentre/Site%20Pages/SafetyHome.aspx"
        },
        {
            "label": "Engineering",
            "url": "https://youlink.srilankan.com/sites/eng/"
        },
        {
            "label": "Finance",
            "url": "https://youlink.srilankan.com/sites/finance/"
        },
        {
            "label": "Flight Operations",
            "url": "https://youlink.srilankan.com/sites/fltops/"
        },
        {
            "label": "Group Assurance Advisory Services",
            "url": "https://youlink.srilankan.com/sites/grpassurance/Pages/group-assurance-and-advisory-home.aspx"
        },
        {
            "label": "Human Resources",
            "url": "https://youlink.srilankan.com/sites/HR/"
        },
        {
            "label": "Information Technology",
            "url": "https://youlink.srilankan.com/sites/IT/"
        },
        {
            "label": "Logistics & Adminstration",
            "url": "https://youlink.srilankan.com/sites/securitylogistics"
        },
        {
            "label": "Marketing",
            "url": "https://youlink.srilankan.com/sites/marketing/"
        },
        {
            "label": "Security Operations",
            "url": "https://youlink.srilankan.com/sites/aviation-security"
        },
        {
            "label": "Service Delivery",
            "url": "https://youlink.srilankan.com/sites/servicedelivery/"
        }
        ]
        }
        """;
        
        guard let data = jsonString.data(using: .utf8) else { return }
        do {
            menuData = try JSONDecoder().decode(MenuData.self, from: data)
        } catch {
            print("JSON decode error:", error)
        }
        
        
    }
    
    
    // Toggle section
    func toggle(sectionKey: String) {
        if expandedSections.contains(sectionKey) {
            expandedSections.remove(sectionKey)
        } else {
            expandedSections.insert(sectionKey)
        }
    }
    
    func isExpanded(sectionKey: String) -> Bool {
        expandedSections.contains(sectionKey)
    }
}
