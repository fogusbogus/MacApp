////
////  SPF+Parser.swift
////  MCResults
////
////  Created by Matt Hogg on 23/01/2023.
////
//
//import Foundation
//import UsefulExtensions
//
//class SPF_Parser {
//
//	static var maxIncludeLookups = 30
//
//	enum Tag {
//		case a, exists, mx, include, redirect, ptr, other
//	}
//
//	enum CircularRefError : Error {
//		case circularReferenceDetected(domain: String), tooManyLookupsInBranch
//	}
//
//	static func checkForCircularRef(_ domain: String, _ checkedDomains: [String] = [], _ maxIncludeLookups: Int = 30, _ completionHandler: @escaping (Result<String, CircularRefError>) -> Void) {
//
//		if checkedDomains.contains(obj: domain) {
//			completionHandler(.failure(CircularRefError.circularReferenceDetected(domain: domain)))
//		}
//		if checkedDomains.count >= maxIncludeLookups {
//			completionHandler(.failure(CircularRefError.tooManyLookupsInBranch))
//		}
//		completionHandler(.success(domain))
//	}
//
//	static func lookup(tag: Tag, value: String, checkedDomains: [String] = []) -> String {
//		switch tag {
//			case .a:
//				return lookupA(value)
//			case .exists:
//				return lookupA(value)
//			case .mx:
//				return lookupMX(value)
//			case .include:
//				return lookupRecord(value, tag, checkedDomains, maxIncludeLookups)
//			case .redirect:
//				return lookupRecord(value, tag, checkedDomains, maxIncludeLookups)
//			case .ptr:
//				return ptrTagNotInUse(tag, value)
//			case .other:
//				return lookupNotSupported(tag, value)
//		}
//	}
//
//	static func lookupA(_ domain: String) -> ISPFResult {
//		var ret : ISPFResult
//		queryGoogleDNS(domain, "A") { res in
//			switch res {
//				case .success(let success):
//					ret = SPFResult_A(tag: "a", value: domain, ips: [success])
//				case .failure(let failure):
//					ret = SPFResult_A_Err(tag: "a", value: domain, error: failure)
//			}
//		}
//		return ret
//	}
//
//	static func queryGoogleDNS(_ domain: String, _ type: String = "TXT", _ completionHandler: @escaping (Result<String, GoogleQueryError>) -> Void) {
//		if domain.isEmptyOrWhitespace() {
//			completionHandler(.failure(GoogleQueryError.noDomainSpecified))
//		}
//		completionHandler(.success("v=spf1"))
//	}
//
//	enum GoogleQueryError : Error {
//		case dnsFailure(domain: String, type: String, errorCode: String), noDomainSpecified
//	}
//}
//
//class ISPFResult {
//	var tag: String = ""
//	var value: String = ""
//}
//
//class SPFResult_A : ISPFResult {
//	init(tag: String, value: String, ips: [String] = []) {
//		self.tag = tag
//		self.value = value
//		self.ips = ips
//	}
//
//	var ips: [String] = []
//}
//
//class SPFResult_A_Err : ISPFResult {
//	init(tag: String, value: String, error: Error) {
//		self.tag = tag
//		self.value = value
//		self.error = error
//	}
//
//	var error: Error
//}
